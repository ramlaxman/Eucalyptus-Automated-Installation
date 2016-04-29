#!/bin/sh
#################################################################################
# Author: Mayur Patil                                                           #
# License: GPLv2                                                                #
# Eucalyptus Installation & configuration script after installing the CentOS    #
# It only deals with usual commands need to configure & setup Eucalyptus.       #
# Now for front end now only.                                                   #
#################################################################################

####
#NOTICE: You must be root to perform following operations.
###

yum install openssh-server      ## INSTALL SSH SERVER-CLIENT
service sshd start
chkconfig sshd on               ## ADD TO STARTUP
system-config-firewall-tui      ## DISABLE THE FIREWALL
cd '/etc/selinux/' 
cp -b config config.back
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' config
setenforce 0
cd '/etc/'
cp -b sysctl.conf sysctl.conf.back
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' sysctl.conf
yum install http://downloads.eucalyptus.com/software/eucalyptus/3.4/centos/6/x86_64/eucalyptus-release-3.4.noarch.rpm \
http://downloads.eucalyptus.com/software/euca2ools/3.0/centos/6/x86_64/euca2ools-release-3.0.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/3.4/centos/6/x86_64/epel-release-6.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/3.4/centos/6/x86_64/elrepo-release-6.noarch.rpm

yum install bridge-utils

read -p "Enter Static IP address: " n1
read -p "Enter Netmask/Prefix: " n2
read -p "Enter gateway: " n3
read -p "Enter DNS Server Address: " n4

cd '/etc/sysconfig/network-scripts/'

echo "DEVICE=eth0
BRIDGE=br0
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
NAME="eth0"
ONBOOT=yes
#IPADDR=$n1
#PREFIX=$n2
#GATEWAY=$n3
#DNS1=$n4
NM_CONTROLLED=no" > ifcfg-eth0

echo "DEVICE=br0
TYPE=Bridge
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
NAME="br0"
ONBOOT=yes
IPADDR=$n1
PREFIX=$n2
GATEWAY=$n3
DNS1=$n4
NM_CONTROLLED=no" > ifcfg-br0

read -p "Press enter to restart the network -> "

service network restart

yum install eucalyptus-nc

ls -l /dev/kvm

