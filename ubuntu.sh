#!/bin/sh

# stty cols 1000; ls /etc/debian_version
# stty cols 1000; cat /etc/issue
# stty cols 1000; lsb_release -ir
# stty cols 1000; type curl
# stty cols 1000; curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id
# stty cols 1000; dpkg-query -W
# stty cols 1000; sudo -S apt-get update
# stty cols 1000; LANGUAGE=en_US.UTF-8 apt-get upgrade --dry-run
# stty cols 1000; LANGUAGE=en_US.UTF-8 apt-cache policy less liblxc1 lxc-common lxd lxd-client

get_instance_id() {
  stty cols 1000
  exec curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id
}

exec_command() {
  stty cols 1000
  exec "$@"
}

IFS=';'
set -- $SSH_ORIGINAL_COMMAND
IFS=' '
set -- $(printf '%s' "$2")

case "$1" in
  LANGUAGE=*)
    shift
    LANGUAGE=en_US.UTF-8
    ;;
esac

case "$1" in
  curl)
    get_instance_id
    ;;
  ls|cat|lsb_release|type|dpkg-query|apt-get|apt-cache)
    exec_command "$@"
    ;;
  sudo)
    exec_command sudo -S apt-get update
    ;;
esac

exit 1

