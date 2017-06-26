# vuls-ssh-command

```
$ sudo adduser -m vuls-user
$ sudo su vuls-user
$ mkdir -m 700 /home/vuls-user/.ssh
$ curl https://raw.githubusercontent.com/asannou/vuls-ssh-command/master/amazon-linux.sh > /home/vuls-user/.ssh/vuls-ssh-command-amazon-linux.sh
$ chmod +x /home/vuls-user/.ssh/vuls-ssh-command-amazon-linux.sh
$ echo 'command="/home/vuls-user/.ssh/vuls-ssh-command-amazon-linux.sh" ssh-rsa ...' > /home/vuls-user/.ssh/authorized_keys
```
