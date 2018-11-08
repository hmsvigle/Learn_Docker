#!/bin/sh
# setupenv-entrypoint.sh

echo "----------------Executing ENTRYPOINT script----------------\n"
# passwordless ssh

echo "----------------setting up passwordless ssh----------------\n"
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys


echo "----------------setup httpd service----------------"
# http setup
service httpd start
systemctl enable httpd

echo "----------------disable firewall----------------"
# firewall
service firewalld stop
systemctl disable firewalld

echo "----------------ntpd setup----------------"
# ntpd
yum install -y ntpd
service ntpd start

echo "----------------install java----------------"
# install java
yum install -y java-1.8.0-openjdk; yum clean all;
mkdir -p /usr/java/default/bin
JAVA_HOME=/usr/java/default
ln -s /usr/bin/java $JAVA_HOME/bin/java
export PATH=$PATH:$JAVA_HOME/bin


