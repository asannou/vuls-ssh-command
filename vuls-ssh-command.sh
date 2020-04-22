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
# stty cols 1000; LANGUAGE=en_US.UTF-8 ps --no-headers --ppid 2 -p 2 --deselect -o pid,comm
# stty cols 1000; sudo -S ls -l /proc/1000/exe
# stty cols 1000; sudo -S cat /proc/1000/maps 2>/dev/null | grep -v " 00:00 " | awk '{print $6}' | sort -n | uniq
# stty cols 1000; sudo -S lsof -i -P -n | grep LISTEN
# stty cols 1000; rpm -qf --queryformat "%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{ARCH}\n" /usr/sbin/ntpd ...
# stty cols 1000; sudo -S stat /proc/1/exe
# stty cols 1000; sudo -S stat /sbin/init
# stty cols 1000; /sbin/init --version
# stty cols 1000; sudo -S LANGUAGE=en_US.UTF-8 needs-restarting
# stty cols 1000; sudo -S LANGUAGE=en_US.UTF-8 which ntpd
# stty cols 1000; LANGUAGE=en_US.UTF-8 rpm -qf --queryformat "%{NAME}-%{EPOCH}:%{VERSION}-%{RELEASE}.%{ARCH}\n" /usr/sbin/ntpd

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
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 ps --no-headers --ppid 2 -p 2 --deselect -o pid,comm'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'stat /proc/1/exe'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 needs-restarting'

# stty cols 1000; docker ps --format '{{.ID}} {{.Names}} {{.Image}}'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls /etc/debian_version'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/issue'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'lsb_release -ir'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /etc/lsb-release'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type curl'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'type wget'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c '/sbin/ip -o addr'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'uname -r'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'test -f /var/run/reboot-required'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'dpkg-query -W -f="\${binary:Package},\${db:Status-Abbrev},\${Version},\${Source},\${source:Version}\n"'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'apt-get update'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 apt-get dist-upgrade --dry-run'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 apt-cache policy '
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 ps --no-headers --ppid 2 -p 2 --deselect -o pid,comm'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls -l /proc/1/exe'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'cat /proc/1/maps 2>/dev/null | grep -v " 00:00 " | awk '{print $6}' | sort -n | uniq'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'ls -l /proc/1000/exe'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'lsof -i -P -n | grep LISTEN'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'dpkg -S /bin/sleep ...'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'stat /proc/1/exe'
# stty cols 1000; docker exec --user 0 deadbeefdead /bin/sh -c 'LANGUAGE=en_US.UTF-8 checkrestart'

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

# https://github.com/future-architect/vuls/tree/v0.9.1/scan
# $ grep 'exec(' *.go | grep -v cmd
# $ grep 'cmd := ' *.go

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
    lsof)
      /bin/echo 'lsof -i -P -n | grep LISTEN'
      ;;
    sudo)
      case "$3" in
        lsof)
          /bin/echo 'sudo -S lsof -i -P -n | grep LISTEN'
          ;;
        cat)
          pid=$(echo $4 | sed -n 's/^\/proc\/\([0-9]\+\)\/maps$/\1/p')
          test -n "$pid" && /bin/echo "sudo -S cat /proc/$pid/maps 2>/dev/null | grep -v \" 00:00 \" | awk '{print \$6}' | sort -n | uniq"
          ;;
      esac
      ;;
    docker)
      case "$2" in
        exec)
          options="--user 0"
          container_id="$5"
          docker_exec="docker exec $options $container_id /bin/sh -c"
          IFS=$(printf '\t')
          set -- $(/bin/echo "$@" | xargs printf '%s\t')
          IFS=' '
          set -- $8
          case "$1" in
            /sbin/ip)
              hostname=$(echo $container_id | cut -c -12)
              /bin/echo "$docker_exec 'while read line; do set -- \$line; test \"\$2\" = \"$hostname\" && echo \"0: eth0 inet \$1/32\"; done < /etc/hosts'"
              ;;
            cat)
              pid=$(echo $2 | sed -n 's/^\/proc\/\([0-9]\+\)\/maps$/\1/p')
              test -n "$pid" && /bin/echo "$docker_exec 'cat /proc/$pid/maps 2>/dev/null | grep -v \" 00:00 \" | awk \"{print \\\$6}\" | sort -n | uniq'"
              ;;
            *)
              command=$(verify_piped_command "$@")
              test -n "$command" && /bin/echo "$docker_exec '$command'"
              ;;
          esac
          ;;
      esac
      ;;
  esac
}

verify_command() {
  case "$1" in
    ls|lsb_release|uname|test|dpkg-query|apt-cache|ps|stat|checkrestart)
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
    /sbin/init)
      /bin/echo /sbin/init --version
      ;;
    /sbin/ip)
      /bin/echo /sbin/ip -o addr
      ;;
    yum)
      case "$2" in
        makecache)
          /bin/echo yum makecache --assumeyes
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
        -qa|-qf)
          /bin/echo "$@"
          ;;
        -q)
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
    dpkg)
      case "$2" in
        -S)
          /bin/echo "$@"
          ;;
      esac
      ;;
    apk)
      case "$2" in
        update|version)
          /bin/echo apk $2
          ;;
        info)
          /bin/echo apk info -v
          ;;
      esac
      ;;
    zypper)
      /bin/echo zypper -V
      ;;
    sudo)
      shift 2
      env=$(verify_env "$@")
      test -n "$env" && shift
      case "$1" in
        apt-get)
          /bin/echo sudo -S apt-get update
          ;;
        stat|ls|needs-restarting|which)
          /bin/echo sudo -S $env "$@"
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
          test -n "$env" && options="$options --env '$env'" && shift
          command=$(verify_command "$@")
          test -n "$command" && /bin/echo docker exec $options $container_id $command
          ;;
      esac
      ;;
  esac
}

IFS=';'
set -- $SSH_ORIGINAL_COMMAND

test_stty "$1" || exit 126

$1
shift

IFS=' '
set -- $(printf ';%s' "$@" | escape | cut -c 2-)

env=$(verify_env "$@")
test -n "$env" && export "$env" && shift

command=$(verify_piped_command "$@")
if [ -n "$command" ]
then
  /bin/sh -c "$command"
  exit
fi

IFS=' '
command=$(verify_command "$@")
test -n "$command" && exec_command $command

exit 126

