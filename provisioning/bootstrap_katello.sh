#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname foreman.linuxsysadmins
echo "192.168.1.20 foreman.linuxsysadmins.local foreman.linuxsysadmins" |sudo tee -a /etc/hosts
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

# https://github.com/spacewalkproject/spacewalk/wiki/HowToInstall
echo "================================== foreman installation  ======================================================="

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

# Starting with Foreman Prerequisites

#  Enable Firewalld
systemctl enable firewalld
systemctl restart firewalld

# adding the ports for katello patch management
firewall-cmd --add-port={53,80,443,5647,9090}/tcp --permanent
# firewall-cmd --add-port="67-69,53/udp" --permanent
firewall-cmd --add-port={67-69,53}/udp --permanent
firewall-cmd --add-port="53/udp" --permanent
firewall-cmd --reload
firewall-cmd --list-all

systemctl restart firewalld
systemctl status firewalld

# # Storage Requirement for Katello Patch Management
# lsblk 
# # setting up a Logical Volume (LVM).
# pvcreate /dev/sdb
# vgcreate vg_pulp /dev/sdb
# lvcreate -l 100%FREE -n lv_pulp vg_pulp
# # Create a filesystem on newly created LVM
# mkfs.xfs /dev/mapper/vg_pulp-lv_pulp 
# # Mount the filesystem and make it persistent
# mkdir /var/lib/pulp
# mount /dev/mapper/vg_pulp-lv_pulp /var/lib/pulp/
# echo "/dev/mapper/vg_pulp-lv_pulp /var/lib/pulp/ xfs defaults 0 0" >> /etc/fstab
# tail -n1 /etc/fstab
# restorecon -Rv /var/lib/pulp/
# # List the created fileSystem 
# df -hP /var/lib/pulp/

# Installing Foreman with Katello

# update the existing packages
yum update -yq
# Add the required Repositories
yum -yq localinstall https://yum.theforeman.org/releases/1.24/el7/x86_64/foreman-release.rpm
yum -yq localinstall https://fedorapeople.org/groups/katello/releases/yum/3.14/katello/el7/x86_64/katello-repos-latest.rpm
yum -yq localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
yum -yq localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -yq foreman-release-scl 

# install the katello
yum install -yq katello 

# To set up with more modules it possible to add them by editing below YAML file
# This should be done before starting with running foreman-installer
cat /etc/foreman-installer/scenarios.d/katello.yaml
cp /vagrant/configs/katello.yaml /etc/foreman-installer/scenarios.d/katello.yaml
cat /etc/foreman-installer/scenarios.d/katello.yaml

# Start the foreman installer to set up the katello
# If the option --scenario katello not used, it will set up with the puppet
foreman-installer --scenario katello --foreman-initial-admin-username admin --foreman-initial-admin-password 'katellopassword'



# monitor the installation progress 
tail -n 40 /var/log/foreman-installer/katello.log

# verify the service status
katello-service status | grep -i "Active"

# Access the foreman GUI using FQDN 
curl https://foreman.linuxsysadmins.local

# perform all actions from the default user “admin” account.
hammer user list