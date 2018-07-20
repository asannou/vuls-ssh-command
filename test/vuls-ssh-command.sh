#!/bin/sh

oneTimeSetUp() {
  LANG=
  container_id=$(docker run -d alpine sleep 1d)
}

oneTimeTearDown() {
  docker rm -f $container_id > /dev/null
}

setUp() {
  cols=$(stty size | cut -d ' ' -f 2)
}

tearDown() {
  stty cols $cols
}

sshCommand() {
  SSH_ORIGINAL_COMMAND="$1" ../vuls-ssh-command.sh
}

testAllow()
{
  sshCommand 'stty cols 1000; ls /etc/debian_version' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; ls /etc/system-release' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; cat /etc/system-release' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; type curl' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/instance-id' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; /sbin/ip -o addr' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; uname -r' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; rpm -qa --queryformat '%{NAME} %{EPOCHNUM} %{VERSION} %{RELEASE} %{ARCH}
'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; rpm -q --last kernel' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; repoquery --all --pkgnarrow=updates --qf="%{NAME} %{EPOCH} %{VERSION} %{RELEASE} %{REPO}"' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; yum --color=never --security updateinfo list updates' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; yum --color=never --security updateinfo updates' > /dev/null 2>&1
  assertNotEquals 126 $?
}

testDockerAllow()
{
  sshCommand "stty cols 1000; docker ps --format '{{.ID}} {{.Names}} {{.Image}}'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker ps --filter 'status=exited' --format '{{.ID}} {{.Names}} {{.Image}}'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls /etc/debian_version'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'cat /etc/issue'" > /dev/null 2>&1
  assertNotEquals 126 $?

  out=$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'lsb_release -ir'")
  assertEquals 126 $?
  assertTrue "echo '$out' | grep -qiE 'oci runtime (error|exec failed): exec failed: '"

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'type curl'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c '/sbin/ip -o addr'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'uname -r'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'test -f /var/run/reboot-required'" > /dev/null 2>&1
  assertNotEquals 126 $?

  out=$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'dpkg-query -W -f="'"\${binary:Package},\${db:Status-Abbrev},\${Version},\${Source},\${source:Version}\n"'"'")
  assertEquals 126 $?
  assertTrue "echo '$out' | grep -qiE 'oci runtime (error|exec failed): exec failed: '"

  out=$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'apt-get update'")
  assertEquals 126 $?
  assertTrue "echo '$out' | grep -qiE 'oci runtime (error|exec failed): exec failed: '"

  out=$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'LANGUAGE=en_US.UTF-8 apt-get dist-upgrade --dry-run'")
  assertEquals 126 $?
  assertTrue "echo '$out' | grep -qiE 'oci runtime (error|exec failed): exec failed: '"

  out=$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'LANGUAGE=en_US.UTF-8 apt-cache policy'")
  assertEquals 126 $?
  assertTrue "echo '$out' | grep -qiE 'oci runtime (error|exec failed): exec failed: '"
}

testDeny()
{
  sshCommand 'stty cols 1000; id' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'stty cols 1000 & id; id' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'id; id' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'id; ls -d /' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'stty cols 1000; cat /etc/passwd' > /dev/null 2>&1
  assertEquals 126 $?
}

testDockerDeny()
{
  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'id'" > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'id; id'" > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'id; ls -d /'" > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'cat /etc/passwd'" > /dev/null 2>&1
  assertEquals 126 $?
}

testTamper()
{
  out="$(sshCommand 'stty cols `id>&2`; ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertTrue "echo '$out' | grep -q 'stty: invalid integer argument'"

  out="$(sshCommand 'stty cols $(id>&2); ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertTrue "echo '$out' | grep -q 'stty: invalid integer argument'"

  out="$(sshCommand 'stty cols 1000 & id; ls -d /' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'stty: invalid argument' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls -d /; id' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls `id`' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls $(id)' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls || id' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls && id' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls & id' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; ls > /dev/null' 2>&1)"
  assertNotEquals 126 $?
  echo "$out" | grep -q 'ls: cannot access ' || fail "$out"

  out="$(sshCommand 'stty cols 1000; curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/iam/security-credentials/__404' 2> /dev/null)"
  assertNotEquals 126 $?
  assertFalse "echo '$out' | grep -q '404 - Not Found'"

  out="$(sshCommand 'stty cols 1000; rpm -q --last kernel | ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertNotEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000; LANGUAGE=`id>&2` ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000; LANGUAGE=$(id>&2) ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"
}

testDockerTamper()
{
  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls -d /; id'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: /;: No such file or directory
ls: id: No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c '"'ls `id`'"'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: `id`: No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c '"'ls $(id)'"'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: $(id): No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls || id'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: ||: No such file or directory
ls: id: No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls && id'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: &&: No such file or directory
ls: id: No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls & id'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: &: No such file or directory
ls: id: No such file or directory' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c 'ls > /dev/null'" 2>&1)"
  assertNotEquals 126 $?
  assertTrue "echo '$out' | grep -q 'No such file or directory'"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c '"'LANGUAGE=`id>&2` ls -d /'"'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand "stty cols 1000; docker exec --user 0 $container_id /bin/sh -c '"'LANGUAGE=$(id>&2) ls -d /'"'" 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"
}

. shunit2/source/2.1/src/shunit2
