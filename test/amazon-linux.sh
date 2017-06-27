#!/bin/sh

oneTimeSetUp() {
  LANG=
}

setUp() {
  cols=$(stty size | cut -d ' ' -f 2)
}

tearDown() {
  stty cols $cols
}

sshCommand() {
  SSH_ORIGINAL_COMMAND="$1" ../amazon-linux.sh
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

  sshCommand "stty cols 1000; rpm -qa --queryformat '%{NAME}	%{VERSION}	%{RELEASE}
'" > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; yum --color=never repolist' > /dev/null 2>&1
  assertNotEquals 126 $?

  sshCommand 'stty cols 1000; LANGUAGE=en_US.UTF-8 yum --color=never check-update' > /dev/null 2>&1
  assertNotEquals 126 $?
}

testDeny()
{
  sshCommand 'stty cols 1000; id' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'stty cols 1000 & id; id' > /dev/null 2>&1
  assertEquals 126 $?

  sshCommand 'id; id' > /dev/null 2>&1
  assertEquals 126 $?
}

testTamper()
{
  out="$(sshCommand 'id; ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols `id>&2`; ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols $(id>&2); ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000 & id; ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000; ls -d /; id' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000; ls `id`' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access `id`: No such file or directory' "$out"

  out="$(sshCommand 'stty cols 1000; ls $(id)' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access $(id): No such file or directory' "$out"

  out="$(sshCommand 'stty cols 1000; ls || id' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access ||: No such file or directory
ls: cannot access id: No such file or directory' "$out"

  out="$(sshCommand 'stty cols 1000; ls && id' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access &&: No such file or directory
ls: cannot access id: No such file or directory' "$out"

  out="$(sshCommand 'stty cols 1000; ls & id' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access &: No such file or directory
ls: cannot access id: No such file or directory' "$out"

  out="$(sshCommand 'stty cols 1000; ls > /dev/null' 2>&1)"
  assertNotEquals 126 $?
  assertEquals 'ls: cannot access >: No such file or directory
/dev/null' "$out"

  out="$(sshCommand 'stty cols 1000; curl --max-time 1 --retry 3 --noproxy 169.254.169.254 http://169.254.169.254/latest/meta-data/iam/security-credentials/__404' 2> /dev/null)"
  assertNotEquals 126 $?
  assertFalse "echo '$out' | grep -q '404 - Not Found'"

  out="$(sshCommand 'stty cols 1000; LANGUAGE=`id>&2` ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"

  out="$(sshCommand 'stty cols 1000; LANGUAGE=$(id>&2) ls -d /' 2>&1)"
  assertNotEquals 126 $?
  assertEquals '/' "$out"
}

. shunit2/source/2.1/src/shunit2
