#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname cobbler-server
echo "192.168.50.22 cobbler-server.local cobbler-server" |sudo tee -a /etc/hosts
cat /etc/hosts

echo "nameserver 8.8.8.8" |sudo tee -a /etc/resolv.conf
cat /etc/resolv.conf

echo "===================================================================================="
                          hostnamectl status
echo "===================================================================================="
echo "         \   ^__^                                                                  "
echo "          \  (oo)\_______                                                          "
echo "             (__)\       )\/\                                                      "
echo "                 ||----w |                                                         "
echo "                 ||     ||                                                         "
echo "========================================================================================="


echo "================================== cobbler installation  ======================================================="

# setting system locale to en_US.utf8
localectl set-locale LC_CTYPE=en_US.utf8
localectl status

hostnamectl status
dnsdomainname -f

# The time Synchronization for a foreman with katello
yum install -yq chrony
systemctl enable chronyd
systemctl start chronyd
systemctl status chronyd
chronyc sources

# Enable NTP synchronization
timedatectl set-ntp true
timedatectl status

# Update System
# enable the EPEL repository
yum -yq install epel-release

# update system with the latest available packages.
yum update -yq

# disable SELinux services 
setenforce 0

cat /etc/selinux/config
# Make the following changes
# restart your server to apply the changes
# SELINUX=disabled


#  Enable Firewalld
systemctl enable firewalld
systemctl restart firewalld


firewall-cmd --add-port={69,80,443,5647,9090}/tcp --permanent
firewall-cmd --add-port={69,4011}/udp --permanent
# firewall-cmd --add-port="53/udp" --permanent
firewall-cmd --reload
firewall-cmd --list-all

# Modify Firewall Rules
# firewall-cmd --add-port=80/tcp --permanent
# firewall-cmd --add-port=443/tcp --permanent
# firewall-cmd --add-service=dhcp --permanent
# firewall-cmd --add-port=69/tcp --permanent
# firewall-cmd --add-port=69/udp --permanent
# firewall-cmd --add-port=4011/udp --permanent
# firewall-cmd --reload

# Install Cobbler

# need to install the Apache web server
yum -yq install httpd

# install Cobbler along with its required dependent packages
yum -yq install cobbler cobbler-web dnsmasq syslinux pykickstart xinetd
yum -yq install cobbler cobbler-web dnsmasq syslinux pykickstart xinetd fence-agents debmirror dhcp bind

# start Cobbler and the Apache web server and enable them to run at boot time
systemctl start cobblerd 
systemctl enable cobblerd 
systemctl status cobblerd 

systemctl start tftp
systemctl enable tftp 
systemctl status tftp 

systemctl start rsyncd
systemctl enable rsyncd 
systemctl status rsyncd 

systemctl start httpd 
systemctl enable httpd
systemctl status httpd

# edit tftp configuration file and make some changes
cat /etc/xinetd.d/tftp
# Make the following changes
# disable = 0

# Configure Cobbler
# Cobbler default configuration file located at /etc/cobbler/settings

# generate encrypt password
# openssl passwd -1

cat /etc/cobbler/settings

cat /etc/cobbler/dhcp.template

cat /etc/cobbler/dnsmasq.template