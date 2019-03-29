#!/bin/sh
#################################################################################
#   Author: Mayur Patil                                                         #
#   License: GPLv2                                                              #
#   Eucalyptus Installation & configuration script after installing the CentOS  #
#   It only deals with usual commands need to configure & setup Eucalyptus.     #
#   Now for front end now only.                                                 #
#################################################################################

#### 
#NOTICE: You must be root to perform following operations.
###

yum install openssh-server      ## INSTALL SSH SERVER & CLIENT
service sshd start
chkconfig sshd on               ## ADD TO STARTUP
system-config-firewall-tui      ## DISABLE THE FIREWALL
cd '/etc/selinux/' || exit 
cp -b config config.back        ## copy config file with backup
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' config        ## Streaming EDitor used to change from source to destination
setenforce 0                    ## copy config file with backup
cd '/etc/' || exit
cp -b sysctl.conf sysctl.conf.back
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' sysctl.conf
yum install http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/eucalyptus-release-4.0.noarch.rpm \
http://downloads.eucalyptus.com/software/euca2ools/3.1/centos/6/x86_64/euca2ools-release-3.1.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/epel-release-6.noarch.rpm \
http://downloads.eucalyptus.com/software/eucalyptus/4.0/centos/6/x86_64/elrepo-release-6.noarch.rpm

yum install eucalyptus-cloud eucalyptus-cc eucalyptus-sc eucalyptus-walrus eucalyptus-console

cd '/etc/eucalyptus/' || exit
read -r "VNET_MODE " v1
read -r "VNET_SUBNET " v2
read -r "VNET_NETMASK " v3
read -r "VNET_DNS " v4
read -r "VNET_ADDRSPERNET " v5
read -r "VNET_PUBLICIPS " v6
read -r "VNET_LOCALIP " v7
#read -r "VNET_DHCPDAEMON " v8
read -r "VNET_DHCPUSER " v8
read -r "VNET_PRIVINTERFACE " v9
read -r "VNET_PUBINTERFACE " v10
read -r "VNET_BRIDGE " v11
read -r "CREATE_SC_LOOP_DEVICES" v12

sed -i "s/#VNET_MODE=\".*\"/VNET_MODE=\"$v1\"/g" eucalyptus.conf
sed -i "s/#VNET_SUBNET=\".*\"/VNET_SUBNET=\"$v2\"/g" eucalyptus.conf
sed -i "s/#VNET_NETMASK=\".*\"/VNET_NETMASK=\"$v3\"/g" eucalyptus.conf
sed -i "s/#VNET_DNS=\".*\"/VNET_DNS=\"$v4\"/g" eucalyptus.conf
sed -i "s/#VNET_ADDRSPERNET=\".*\"/VNET_ADDRSPERNET=\"$v5\"/g" eucalyptus.conf 
sed -i "s/#VNET_PUBLICIPS=\".*\"/VNET_PUBLICIPS=\"$v6\"/g" eucalyptus.conf
sed -i "s/#VNET_LOCALIP=\".*\"/VNET_LOCALIP=\"$v7\"/g" eucalyptus.conf
sed -i "s/#VNET_DHCPDAEMON=\"\/usr\/sbin\/dhcpd41\"/VNET_DHCPDAEMON=\"\/usr\/sbin\/dhcpd41\"/g" eucalyptus.conf
sed -i "s/#VNET_DHCPUSER=\".*\"/VNET_DHCPUSER=\"$v8\"/g" eucalyptus.conf
sed -i "s/#VNET_PRIVINTERFACE=\".*\"/VNET_PRIVINTERFACE=\"$v9\"/g" eucalyptus.conf
sed -i "s/#VNET_PUBINTERFACE=\".*\"/VNET_PUBINTERFACE=\"$v10\"/g" eucalyptus.conf
sed -i "s/#VNET_BRIDGE=\".*\"/VNET_BRIDGE=\"$v11\"/g" eucalyptus.conf
sed -i "s/#CREATE_SC_LOOP_DEVICES=.*/CREATE_SC_LOOP_DEVICES=\"$v12\"/g" eucalyptus.conf

/usr/sbin/euca_conf --initialize
echo "Cloud has initialized...."
service eucalyptus-cloud start
service eucalyptus-cc start
service eucalyptus-console start

read -r 'Enter CLC IP: ' clc1
read -r 'Enter Walrus Component name: ' clc2 
read -r 'Enter Cluster Controller (CC) Partition name: ' clc3
read -r 'Enter Storage Controller (SC) Partition name: ' clc4
read -r 'Enter CC Component name: ' clc5
read -r 'Enter SC Component name: ' clc6

/usr/sbin/euca_conf --register-walrus --partition walrus --host "$clc1" --component "$clc2"
/usr/sbin/euca_conf --register-cluster --partition "$clc3"  --host "$clc1" --component "$clc5"
/usr/sbin/euca_conf --register-sc --partition "$clc4" --host "$clc1" --component "$clc6"
/usr/sbin/euca_conf --get-credentials admin.zip
unzip admin.zip
source eucarc

euca-modify-property -p "$clc4".storage.blockstoragemanager=overlay

read -r "if above output is something like this, \
PROPERTY	PARTI00.storage.blockstoragemanager	overlay was <unset>, \
then you are done !!" 
euca-describe-properties | grep blockstorage

read -r "###### To check sc is working properly #######"
euca-describe-services "$clc6"

read -r "#### Cloud is working now, to check status of available resources ####"
euca-describe-availability-zones

read -r "To display images from Eustore, press enter"
eustore-describe-images

read -r "Enter Image ID: " id1
eustore-install-image "$id1"

echo "The images installed are:"
euca-describe-images --filter image-id=emi-*

###Enter the EMI ID ###
read -r "Enter EMI ID of Eucalyptus: " id2
euca-modify-image-attribute -l "$id2" -a all

read -r "Create The Keypair: " id3
euca-create-keypair "$id3" > "$id3".private
chmod 400 "$id3".private
## check whether keypair has created or not ##
euca-describe-keypairs

### to create the basic security group ###
read -r "Enter Name of Security group: " id4 
read -r "Enter the description: " id5
euca-create-group "$id4" -d "$id5"
euca-authorize -P tcp -p 22 -s 0.0.0.0/0 default
euca-authorize -P tcp -p 5900-5910 -s 0.0.0.0/0 default
euca-authorize -P tcp -p 3389 -s 0.0.0.0/0 default
euca-authorize -P icmp -s 0.0.0.0/0 default

read -r "Press enter to run instance:"
euca-run-instances "$id2" -k "$id3"

read -r "Enter Instance ID: " id4

read -r "To check instance state, press enter"
euca-describe-instances "$id4"

echo "Press enter only if your instance state is running"

read -r "Enter the IP address [Public] of Instance: " id6
read -r "User is either root or ec2-user. Enter User: " id7
if [ "$id7" = "root" ];
then
   ssh -i dare.private root@"$id6"
else [ "$id7" = "ec2-user" ]
   ssh -i dare.private ec2-user@"$id6"
fi
