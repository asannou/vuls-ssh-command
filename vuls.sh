#!/bin/sh

set -e

describe_instances() {
  aws ec2 describe-instances --output text --filters 'Name=tag:Vuls,Values=1' --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0]]'
}

send_command() {
  aws ssm send-command --document-name CreateVulsUser --instance-ids $1 --parameters publickey="$2" --output text --query Command.CommandId
}

get_command_invocation() {
  aws ssm get-command-invocation --command-id $1 --instance-id $2 --output text --query '[Status,StandardOutputContent]'
}

fetch_nvd() {
  docker run --rm -it -v $PWD:/vuls -v $PWD/go-cve-dictionary-log:/var/log/vuls vuls/go-cve-dictionary fetchnvd "$@"
}

run_vuls() {
  docker run --rm -it -v $PWD/ssh:/root/.ssh:ro -v $PWD:/vuls -v $PWD/log:/var/log/vuls vuls/vuls "$@"
}

if [ ! -d ssh ]
then
  mkdir -m 700 ssh
  ssh-keygen -N '' -f ssh/id_rsa
fi

cp /dev/null ssh/known_hosts
cp $(dirname $0)/config.toml.default config.toml

describe_instances | while read INSTANCE
do

  IFS=$'\t'
  set -- $INSTANCE
  INSTANCE_ID=$1
  NAME=$2

  PUBLIC_KEY="$(cat ssh/id_rsa.pub)"
  COMMAND_ID=$(send_command $INSTANCE_ID "$PUBLIC_KEY")

  while :
  do
    sleep 1
    INVOCATION=$(get_command_invocation $COMMAND_ID $INSTANCE_ID)
    IFS=$'\t'
    set -- $INVOCATION
    STATUS=$1
    KNOWN_HOSTS="$2"
    [ "$STATUS" = Success ] && break
  done

  IFS=' '
  set -- $KNOWN_HOSTS
  HOST=$1

  echo "$KNOWN_HOSTS" >> ssh/known_hosts

  cat <<__EOD__ >> config.toml
[servers.$NAME]
host = "$HOST"
__EOD__

done

fetch_nvd -last2y
run_vuls scan
run_vuls report "$@"

