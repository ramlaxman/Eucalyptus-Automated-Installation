#!/bin/sh
#################################################################################
# Author: Mayur Patil                                                           #
# License: GPLv2                                                                #
#                                                                               #
# Eucalyptus Installation & configuration script after installing the CentOS    #
# It only deals with usual commands need to configure & setup Eucalyptus.       #
# Pure Node Controller Installer without networking                             #
#################################################################################

####
#NOTICE: You must be root to perform following operations.
###

yum install openssh-server ## INSTALL SSH SERVER & CLIENT
service sshd start
chkconfig sshd on ## ADD TO STARTUP
system-config-firewall-tui ## DISABLE THE FIREWALL
cd '/etc/selinux/'
cp -b config config.back
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' config
setenforce 0
cd '/etc/'
cp -b sysctl.conf sysctl.conf.back
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' sysctl.conf
yum install http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/eucalyptus-release-3.4.noarch.rpm \
http://downloads.eucalyptus.com/software/euca2ools/3.1/centos/6/x86_64/euca2ools-release-3.0.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/epel-release-6.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/elrepo-release-6.noarch.rpm

yum install bridge-utils

yum install eucalyptus-nc

ls -l /dev/kvm

