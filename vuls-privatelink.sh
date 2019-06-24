#!/bin/sh

set -e

export AWS_DEFAULT_REGION=ap-northeast-1

DOCKER_IMAGE=vuls/vuls@sha256:6cfecadb1d5b17c32375a1a2e814e15955c140c67e338024db0c6e81c3560c80
DOCKER_CVE_IMAGE=vuls/go-cve-dictionary

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
TARGET_ACCOUNT_ID=$1
shift

MAC=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ | head -n 1)
VPC_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}vpc-id)
SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC}subnet-id)
ROLE_ARN=arn:aws:iam::$TARGET_ACCOUNT_ID:role/VulsRole-$ACCOUNT_ID
ROLE_SESSION_NAME=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
BUCKET_NAME=vuls-ssm-output-$ACCOUNT_ID-$TARGET_ACCOUNT_ID

assume_role() {
  set -- $(aws sts assume-role \
    --role-arn $ROLE_ARN \
    --role-session-name $ROLE_SESSION_NAME \
    --output text \
    --query Credentials.[AccessKeyId,SecretAccessKey,SessionToken])
  ACCESS_KEY_ID=$1
  SECRET_ACCESS_KEY=$2
  SESSION_TOKEN=$3
}

assumed_aws() {
  AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY \
  AWS_SESSION_TOKEN=$SESSION_TOKEN \
    aws "$@"
}

describe_security_group() {
  aws --output text \
    ec2 describe-security-groups \
    --filters 'Name=group-name,Values=vuls-privatelink' "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[0].GroupId'
}

describe_vpce_svc() {
  assumed_aws --output text \
    ec2 describe-vpc-endpoint-service-configurations \
    --filters 'Name=tag:Name,Values=vuls' \
    --query 'ServiceConfigurations[].[ServiceId,ServiceName,NetworkLoadBalancerArns[0]]'
}

create_tag() {
  aws --output text \
    ec2 create-tags \
    --resources $@ \
    --tags 'Key=Name,Value=vuls'
}

create_vpce() {
  security_group=$(describe_security_group)
  aws --output text \
    ec2 create-vpc-endpoint \
    --vpc-endpoint-type Interface \
    --service-name $1 \
    --vpc-id $VPC_ID \
    --subnet-ids $SUBNET_ID \
    --security-group-ids $security_group \
    --query 'VpcEndpoint.[VpcEndpointId,DnsEntries[0].DnsName]'
}

accept_vpce() {
  outfile=$(mktemp)
  assumed_aws --output text \
    lambda invoke \
    --function-name vuls-accept-vpc-endpoint-connections \
    --payload '{"serviceId": "'$1'", "vpcEndpointIds": ["'$2'"]}' \
    $outfile > /dev/null
  jp.py -f $outfile 'Unsuccessful[]'
  rm $outfile
}

describe_vpce_state() {
  aws --output text \
    ec2 describe-vpc-endpoints \
    --vpc-endpoint-ids $1 \
    --query 'VpcEndpoints[0].State'
}

wait_vpce() {
  for i in $(seq 10)
  do
    state=$(describe_vpce_state $1)
    test "$state" = 'available' && return
    sleep 30
  done
  return 1
}

delete_vpces() {
  aws --output text \
    ec2 delete-vpc-endpoints \
    --vpc-endpoint-ids $@ \
    --query 'Unsuccessful[]'
}

describe_listeners() {
  assumed_aws --output text \
    elbv2 describe-listeners \
    --load-balancer-arn $1 \
    --query 'Listeners[].[Port,DefaultActions[0].TargetGroupArn]'
}

describe_target() {
  assumed_aws --output text \
    elbv2 describe-target-health \
    --target-group-arn $1 \
    --query 'TargetHealthDescriptions[0].[Target.Id,TargetHealth.State]'
}

describe_instance() {
  assumed_aws --output text \
    ec2 describe-instances \
    --instance-ids $1 \
    --filters 'Name=tag:Vuls,Values=1' \
    --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0]]'
}

send_command() {
  assumed_aws --output text \
    ssm send-command \
    --document-name CreateVulsUser \
    --instance-ids $1 \
    --parameters publickey="$2" \
    --output-s3-bucket-name $BUCKET_NAME \
    --query 'Command.CommandId' || true
}

list_commands() {
  assumed_aws --output text \
    ssm list-commands \
    --command-id $1 \
    --instance-id $2 \
    --query 'Commands[0].Status'
}

get_object() {
  assumed_aws \
    s3 cp \
    s3://$BUCKET_NAME/$1/$2/awsrunShellScript/runShellScript/stdout -
}

check_docker() {
  ssh -n \
    -o ConnectionAttempts=3 \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=yes \
    -o UserKnownHostsFile=ssh/known_hosts \
    -i ssh/id_rsa \
    -p $2 \
    vuls@$1 \
    'stty cols 1000; type docker' > /dev/null 2>&1
}

create_vpces() {
  describe_vpce_svc | while read vpce_svc
  do
    set -- $vpce_svc
    vpce_svc_id=$1
    vpce_svc_name=$2
    vpce_svc_lb=$3

    set -- $(create_vpce $vpce_svc_name)
    vpce_id=$1
    vpce_name=$2

    create_tag $vpce_id
    unsuccessful=$(accept_vpce $vpce_svc_id $vpce_id)
    test "$unsuccessful" != '[]' && continue
    echo "$vpce_id $vpce_name $vpce_svc_lb"
  done | \
  while read vpce
  do
    set -- $vpce
    wait_vpce $1 || continue
    echo $vpce
  done
}

send_public_key() {
  public_key="$(cat ssh/id_rsa.pub)"
  command_id=$(send_command $1 "$public_key")
  test -z "$command_id" && return 1
  for i in $(seq 10)
  do
    sleep 1
    status=$(list_commands $command_id $1)
    if [ "$status" = Success ]
    then
      known_host=$(get_object $command_id $1)
      set -- $known_host
      shift
      echo $@
      return
    elif [ "$status" = Failed ]
    then
      return 1
    fi
  done
  return 1
}

make_server_config() {
  cat <<__EOD__
[servers."$1"]
host = "$2"
port = "$3"
__EOD__
}

make_containers_config() {
  cat <<__EOD__
[servers."$1".containers]
includes = ["\${running}"]
__EOD__
}

make_config() {
  create_vpces | while read vpce
  do
    set -- $vpce
    vpce_id=$1
    vpce_name=$2
    vpce_svc_lb=$3
    printf '%s ' $vpce_id

    describe_listeners $vpce_svc_lb | while read listener
    do
      set -- $listener
      port=$1
      target_group=$2

      set -- $(describe_target $target_group)
      target=$1
      state=$2

      if [ "$state" = 'healthy' ]
      then
        IFS=$'\t'
        set -- $(describe_instance $target)
        IFS=$' \t\n'
        id=$1
        name=$2
        if [ -n "$id" ]
        then
          public_key="$(cat ssh/id_rsa.pub)"
          known_host=$(send_public_key $id "$public_key")
          test -z "$known_host" && continue
          echo "[$vpce_name]:$port $known_host" >> ssh/known_hosts
          test -z "$name" && name=$id
          make_server_config $name $vpce_name $port >> config.toml
          if check_docker $vpce_name $port
          then
            make_containers_config $name >> config.toml
          fi
        fi
      fi
    done
  done
}

run_cve() {
  docker pull $DOCKER_CVE_IMAGE
  docker run --rm -i \
    -v $PWD:/vuls \
    -v $PWD/go-cve-dictionary-log:/var/log/vuls \
    $DOCKER_CVE_IMAGE \
    "$@"
}

run_vuls() {
  docker run --rm -i \
    -v $PWD/ssh:/root/.ssh:ro \
    -v $PWD:/vuls \
    -v $PWD/log:/var/log/vuls \
    $DOCKER_IMAGE \
    "$@"
}

if [ ! -d ssh ]
then
  mkdir -m 700 ssh
  ssh-keygen -N '' -f ssh/id_rsa
fi

cp /dev/null ssh/known_hosts
cp $(dirname $0)/config.toml.default config.toml

assume_role

vpce_ids=$(make_config || exit 1)
run_cve fetchnvd -last2y
run_cve fetchjvn -last2y
run_vuls scan
run_vuls report "$@"

delete_vpces $vpce_ids

