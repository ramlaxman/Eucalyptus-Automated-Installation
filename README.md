Eucalyptus Automated Installation
================

This script is about the more automating process of Eucalyptus Standard installation for two separate machines:

*  Front end (CLC,W,SC,CC)
  
*  Node Controller (NC)

Currently, works for MANAGED-NOVLAN mode for Front End and One Node controller only.

###Note: Those who are totally new to Cloud or Linux or Eucalyptus, I will recommend them to use 

- pure-frontend-install.sh
- pure-nc-script.sh

and configure the network manually as directed in Euca Install Guide.


##Known Issues

Bridge interface problem might occur due to automated settings and types of networks.

I will recommend to manually configure this.


##Prerequisites

- CentOS Live DVD 64 Bits

- Internet Connection [Its always good to have Fast Internet Connection: By Internet Savvy Buddy]


##Installation

I will recommend to use CentOS Live DVD:

http://centos.mirror.net.in/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-LiveDVD.iso

which will save your time to download and install extra packages.

After Installing this, do the following procedure:

1. Download project zip package.

2. Please remember all sctipts MUST be in one & same folder only.

3. Extract All files.

4. Go to terminal ( I supposed your directory is /root/Downloads/)

5. [root@raghav Downloads]# chmod 755 Euca-managed-novlan-front.sh

6. [root@raghav Downloads]# ./Euca-managed-novlan-front.sh

Now, give your inputs and just watch the terminal.

Now it will become the Question and Answer session and Ta.........da.....!!

Your Eucalyptus Cloud is ready !!

Enjoy !
