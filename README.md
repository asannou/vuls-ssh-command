# vuls-ssh-command

Restrict commands via SSH like `curl http://169.254.169.254/latest/meta-data/iam/security-credentials/role_name`.

## Create a Vuls User

```
$ sudo adduser -m vuls
$ sudo su vuls
$ mkdir -m 700 /home/vuls/.ssh
```

## Install

```
$ curl https://raw.githubusercontent.com/asannou/vuls-ssh-command/master/vuls-ssh-command.sh > /home/vuls/.ssh/vuls-ssh-command.sh
$ chmod +x /home/vuls/.ssh/vuls-ssh-command.sh
$ echo 'command="/home/vuls/.ssh/vuls-ssh-command.sh" ssh-rsa ...' > /home/vuls/.ssh/authorized_keys
```
