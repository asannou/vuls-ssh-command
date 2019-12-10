#!/bin/sh

#/bin/echo "$SSH_ORIGINAL_COMMAND" >> /tmp/vuls-ssh-command.debug

# stty cols 1000; ls /etc/debian_version
# stty cols 1000; ls /etc/fedora-release
# stty cols 1000; ls /etc/oracle-release
# stty cols 1000; ls /etc/centos-release
# stty cols 1000; ls /etc/redhat-release
# stty cols 1000; ls /etc/system-release
# stty cols 1000; cat /etc/system-release
# stty cols 1000; type curl
# stty cols 1000; curl --max-time 1 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id
# stty cols 1000; /sbin/ip -o addr
# stty cols 1000; uname -r
# stty cols 1000; rpm -qa --queryformat "%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{ARCH}\n"
# stty cols 1000; rpm -q --last kernel
# stty cols 1000; yum makecache --assumeyes
# stty cols 1000; repoquery --version | grep dnf
# stty cols 1000; repoquery --all --pkgnarrow=updates --qf='%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{REPO}'

# stty cols 1000; docker ps --format '{{.ID}} {{.Names}} {{.Image}}'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/debian_version'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/fedora-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/oracle-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/centos-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/redhat-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/system-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/system-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type curl'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'curl --max-time 1 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c '/sbin/ip -o addr'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname -r'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'rpm -qa --queryformat "%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{ARCH}\n"'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'rpm -q --last kernel'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'yum makecache --assumeyes'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'repoquery --version | grep dnf'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'repoquery --all --pkgnarrow=updates --qf='%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{REPO}''

# stty cols 1000; docker ps --format '{{.ID}} {{.Names}} {{.Image}}'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/debian_version'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/issue'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'lsb_release -ir'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/lsb-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/debian_version'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type curl'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type wget'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c '/sbin/ip -o addr'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname -r'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname -a'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'test -f /var/run/reboot-required'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'dpkg-query -W -f="\${binary:Package},\${db:Status-Abbrev},\${Version},\${Source},\${source:Version}\n"'

# stty cols 1000; docker ps --format '{{.ID}} {{.Names}} {{.Image}}'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/debian_version'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/fedora-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/oracle-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/centos-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/redhat-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/system-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/os-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'zypper -V'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/alpine-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/alpine-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type curl'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type wget'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'wget --tries=3 --timeout=1 --no-proxy -q -O - http://169.254.169.254/latest/meta-data/instance-id'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c '/sbin/ip -o addr'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'apk update'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname -r'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'apk info -v'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'apk version'

test_stty() {
  IFS=' '
  set -- $1
  test "$1" = "stty" -a "$2" = "cols"
}

escape() {
  tr '\n' '\0' | sed 's/\x0/\\n/g;s/\t/\\t/g'
}

exec_command() {
  IFS=$(printf '\t')
  set -- $(/bin/echo "$@" | xargs printf '%s\t')
  exec "$@"
}

verify_env() {
  case "$1" in
    LANGUAGE=*)
      /bin/echo "$1"
      ;;
  esac
}

verify_piped_command() {
  case "$1" in
    repoquery)
      case "$2" in
        --version)
          /bin/echo 'repoquery --version | grep dnf'
          ;;
      esac
      ;;
    docker)
      case "$2" in
        exec)
          options="--user 0"
          container_id="$5"
          IFS=$(printf '\t')
          set -- $(/bin/echo "$@" | xargs printf '%s\t')
          IFS=' '
          set -- $8
          case "$1" in
            /sbin/ip)
              /bin/echo "docker exec $options $container_id /bin/sh -c 'while read line; do set -- \$line; test \"\$2\" = \"$container_id\" && echo \$1; done < /etc/hosts'"
              ;;
            *)
              command=$(verify_piped_command "$@")
              if [ -n "$command" ]
              then
                /bin/echo "docker exec $options $container_id /bin/sh -c '$command'"
              fi
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

verify_command() {
  case "$1" in
    ls|lsb_release|uname|test|dpkg-query|apt-cache)
      /bin/echo "$@"
      ;;
    cat)
      IFS='/'
      set -- $2
      case "$2" in
        etc)
          case "$3" in
            debian_version|fedora-release|oracle-release|centos-release|redhat-release|system-release|os-release|alpine-release|issue|lsb-release)
              /bin/echo cat /$2/$3
              ;;
          esac
          ;;
      esac
      ;;
    type)
      case "$2" in
        curl|wget|docker)
          /bin/echo "sh -c 'type $2'"
          ;;
      esac
      ;;
    curl)
      /bin/echo curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id
      ;;
    wget)
      /bin/echo wget --tries=3 --timeout=1 --no-proxy -q -O - http://169.254.169.254/latest/meta-data/instance-id
      ;;
    /sbin/ip)
      /bin/echo /sbin/ip -o addr
      ;;
    yum)
      case "$2" in
        --color=never)
          /bin/echo yum --color=never --security updateinfo $5 $6
          ;;
        makecache)
          /bin/echo "$@"
          ;;
      esac
      ;;
    repoquery)
      case "$2" in
        --all)
          /bin/echo 'repoquery --all --pkgnarrow=updates --qf="%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{REPO}"'
          ;;
      esac
      ;;
    rpm)
      case "$2" in
        -qa)
          /bin/echo "$@"
          ;;
        *)
          /bin/echo rpm -q --last kernel
          ;;
      esac
      ;;
    apt-get)
      case "$2" in
        update)
          /bin/echo apt-get update
          ;;
        dist-upgrade)
          /bin/echo apt-get dist-upgrade --dry-run
          ;;
      esac
      ;;
    apk)
      case "$2" in
        update)
          /bin/echo apk update
          ;;
        info)
          /bin/echo apk info -v
          ;;
        version)
          /bin/echo apk version
          ;;
      esac
      ;;
    sudo)
      case "$3" in
        apt-get)
          /bin/echo sudo -S apt-get update
          ;;
      esac
      ;;
    docker)
      case "$2" in
        ps)
          /bin/echo "$@"
          ;;
        exec)
          options="--user 0"
          container_id="$5"
          IFS=$(printf '\t')
          set -- $(/bin/echo "$@" | xargs printf '%s\t')
          IFS=' '
          set -- $8
          env=$(verify_env "$@")
          if [ -n "$env" ]
          then
            options="$options --env '$env'"
            shift
          fi
          command=$(verify_command "$@")
          if [ -n "$command" ]
          then
            /bin/echo docker exec $options $container_id $command
          fi
          ;;
      esac
      ;;
  esac
}

IFS=';'
set -- $SSH_ORIGINAL_COMMAND

if test_stty "$1"
then
  $1
  shift
else
  exit 126
fi

IFS=' '
set -- $(printf ';%s' "$@" | escape | cut -c 2-)

env=$(verify_env "$@")
if [ -n "$env" ]
then
  export "$env"
  shift
fi

command=$(verify_piped_command "$@")
if [ -n "$command" ]
then
  /bin/sh -c "$command"
  exit
fi

IFS=' '
set -- $(verify_command "$@")

if [ -n "$1" ]
then
  exec_command "$@"
fi

exit 126

