#!/bin/sh

USER=vuls
DOTSSH=/home/$USER/.ssh
COMMAND=$DOTSSH/vuls-ssh-command.sh

adduser -m $USER
mkdir -m 700 $DOTSSH
curl -s -o $COMMAND https://raw.githubusercontent.com/asannou/vuls-ssh-command/master/vuls-ssh-command.sh
echo "command=\"$COMMAND\" {{publickey}}" > $DOTSSH/authorized_keys
chmod 700 $COMMAND
chown -R $USER:$USER $DOTSSH

PUBLICIP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
HOSTKEY=$(cat /etc/ssh/ssh_host_ecdsa_key.pub)

printf '%s %s' $PUBLICIP "$HOSTKEY"
exec > /dev/null

ls /etc/redhat-release && printf '%s\n' $USER' ALL=(ALL) NOPASSWD:/usr/bin/yum --color=never repolist, /usr/bin/yum --color=never --security updateinfo list updates, /usr/bin/yum --color=never --security updateinfo updates, /usr/bin/repoquery, /usr/bin/yum --color=never changelog all *' 'Defaults:'$USER' env_keep="http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"' > /etc/sudoers.d/vuls

ls /etc/debian_version && printf '%s\n' $USER' ALL=(ALL) NOPASSWD: /usr/bin/apt-get update' 'Defaults:'$USER' env_keep="http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"' > /etc/sudoers.d/vuls

if type docker
then
  groupadd docker
  usermod -aG docker $USER
fi
