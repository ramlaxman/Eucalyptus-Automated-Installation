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
mv /root/ncscript.sh /home/samp
cd '/home/samp'
read -p "VNET_MODE " v1
read -p "VNET_BRIDGE " v2
read -p "CREATE_NC_LOOP_DEVICES" v3
sed -i "s/#VNET_MODE=\".*\"/VNET_MODE=\"$v1\"/g" euca.conf
sed -i "s/#VNET_BRIDGE=\".*\"/VNET_BRIDGE=\"$v2\"/g" euca.conf
sed -i "s/#CREATE_NC_LOOP_DEVICES=.*/CREATE_NC_LOOP_DEVICES=\"$v3\"/g" euca.conf

