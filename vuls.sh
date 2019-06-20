#!/bin/sh

set -e

export AWS_DEFAULT_REGION=ap-northeast-1

DOCKER_IMAGE=vuls/vuls@sha256:6cfecadb1d5b17c32375a1a2e814e15955c140c67e338024db0c6e81c3560c80
DOCKER_CVE_IMAGE=vuls/go-cve-dictionary

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
TARGET_ACCOUNT_ID=$1
shift

ROLE_ARN=arn:aws:iam::$TARGET_ACCOUNT_ID:role/VulsRole-$ACCOUNT_ID
ROLE_SESSION_NAME=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
BUCKET_NAME=vuls-ssm-output-$ACCOUNT_ID-$TARGET_ACCOUNT_ID

assume_role() {
  set -- $(aws sts assume-role --role-arn $ROLE_ARN --role-session-name $ROLE_SESSION_NAME --output text --query Credentials.[AccessKeyId,SecretAccessKey,SessionToken])
  export AWS_ACCESS_KEY_ID=$1 AWS_SECRET_ACCESS_KEY=$2 AWS_SESSION_TOKEN=$3
}

describe_instances() {
  aws ec2 describe-instances --output text --filters 'Name=instance-state-name,Values=running' 'Name=tag:Vuls,Values=1' --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0],PublicIpAddress]'
}

send_command() {
  aws ssm send-command --document-name CreateVulsUser --instance-ids $1 --parameters publickey="$2" --output-s3-bucket-name $BUCKET_NAME --output text --query Command.CommandId
}

list_commands() {
  aws ssm list-commands --command-id $1 --instance-id $2 --output text --query 'Commands[0].Status'
}

get_object() {
  aws s3 cp s3://$BUCKET_NAME/$1/$2/awsrunShellScript/runShellScript/stdout -
}

check_docker() {
  ssh -tt -o ConnectionAttempts=3 -o ConnectTimeout=10 -o StrictHostKeyChecking=yes -o UserKnownHostsFile=ssh/known_hosts -i ssh/id_rsa vuls@$1 'stty cols 1000; type docker' > /dev/null 2>&1
}

fetch_nvd() {
  docker pull $DOCKER_CVE_IMAGE
  docker run --rm -i -v $PWD:/vuls -v $PWD/go-cve-dictionary-log:/var/log/vuls $DOCKER_CVE_IMAGE fetchnvd "$@"
  docker run --rm -i -v $PWD:/vuls -v $PWD/go-cve-dictionary-log:/var/log/vuls $DOCKER_CVE_IMAGE fetchjvn "$@"
}

run_vuls() {
  docker run --rm -i -v $PWD/ssh:/root/.ssh:ro -v $PWD:/vuls -v $PWD/log:/var/log/vuls $DOCKER_IMAGE "$@"
}

if [ ! -d ssh ]
then
  mkdir -m 700 ssh
  ssh-keygen -N '' -f ssh/id_rsa
fi

cp /dev/null ssh/known_hosts
cp $(dirname $0)/config.toml.default config.toml

assume_role

describe_instances | while read INSTANCE
do

  IFS=$'\t'
  set -- $INSTANCE
  INSTANCE_ID=$1
  NAME=$2
  PUBLIC_IP_ADDRESS=$3

  [ "$PUBLIC_IP_ADDRESS" = None ] && continue

  PUBLIC_KEY="$(cat ssh/id_rsa.pub)"
  COMMAND_ID=$(send_command $INSTANCE_ID "$PUBLIC_KEY")

  while :
  do
    sleep 1
    STATUS=$(list_commands $COMMAND_ID $INSTANCE_ID)
    if [ "$STATUS" = Success ]
    then
      KNOWN_HOSTS=$(get_object $COMMAND_ID $INSTANCE_ID)
      break
    elif [ "$STATUS" = Failed ]
    then
      exit 1
    fi
  done

  IFS=' '
  set -- $KNOWN_HOSTS
  HOST=$1

  echo "$KNOWN_HOSTS" >> ssh/known_hosts

  cat <<__EOD__ >> config.toml
[servers."$NAME"]
host = "$HOST"
__EOD__

  if check_docker $HOST
  then
    cat <<__EOD__ >> config.toml
[servers."$NAME".containers]
includes = ["\${running}"]
__EOD__
  fi

done

fetch_nvd -last2y
run_vuls scan
run_vuls report "$@"

