# vuls-ssh-command

## Create a Vuls User

```
$ sudo adduser -m vuls
$ sudo su vuls
$ mkdir -m 700 /home/vuls/.ssh
```

## Install

### Amazon Linux

```
$ curl https://raw.githubusercontent.com/asannou/vuls-ssh-command/master/amazon-linux.sh > /home/vuls/.ssh/vuls-ssh-command.sh
$ chmod +x /home/vuls/.ssh/vuls-ssh-command.sh
$ echo 'command="/home/vuls/.ssh/vuls-ssh-command.sh" ssh-rsa ...' > /home/vuls/.ssh/authorized_keys
```
