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



# # monitor the installation progress 
# tail -n 40 /var/log/foreman-installer/katello.log

# # verify the service status
# katello-service status | grep -i "Active"

# # Access the foreman GUI using FQDN 
# curl https://foreman.linuxsysadmins.local

# # perform all actions from the default user “admin” account.
# hammer user list

# # Post Installation configuration

# # Creating Product
# # set up with CentOS repositories
# # By default, one organization with ID 1
# hammer organization list

# # Creating Product from CLI using the hammer
# hammer product create --organization-id 1 --name "CentOS 7 Linux x86_64" --description "Repository for CentOS 7 Linux"

# # Importing GPG Key for OS Repo
# mkdir -p /etc/pki/rpm-gpg/import
# yum install -yq wget 
# wget -P /etc/pki/rpm-gpg/import/ http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7

# # know all GPG keys navigate to
# # https://www.centos.org/keys/

# # import the key for our organization
# # Run this command from the location where the GPG key is downloaded
# hammer gpg create --organization-id 1 --key "RPM-GPG-KEY-CentOS-7" --name "RPM-GPG-KEY-CentOS-7"

# # Creating Repositories

# # Add the CentOS 7 main OS Repository
# hammer repository create --organization-id 1 \
#    --product "CentOS 7 Linux x86_64" \
#    --name "CentOS 7 OS x86_64" \
#    --label "CentOS_7_OS_x86_64" \
#    --content-type "yum" \
#    --download-policy "on_demand" \
#    --gpg-key "RPM-GPG-KEY-CentOS-7" \
#    --url "http://mirror.centos.org/centos-7/7/os/x86_64/" \
#    --mirror-on-sync "no"

# # add Extra repository
# hammer repository create --organization-id 1 \
#    --product "CentOS 7 Linux x86_64" \
#    --name "CentOS 7 Extra x86_64" \
#    --label "CentOS_7_Extra_x86_64" \
#    --content-type "yum" \
#    --download-policy "on_demand" \
#    --gpg-key "RPM-GPG-KEY-CentOS-7" \
#    --url "http://mirror.centos.org/centos-7/7/extras/x86_64/" \
#    --mirror-on-sync "no"

# # receive the updates create the Update Repo
# hammer repository create --organization-id 1 \
#    --product "CentOS 7 Linux x86_64" \
#    --name "CentOS 7 Updates x86_64" \
#    --label "CentOS_7_Updates_x86_64" \
#    --content-type "yum" \
#    --download-policy "on_demand" \
#    --gpg-key "RPM-GPG-KEY-CentOS-7" \
#    --url "http://mirror.centos.org/centos-7/7/updates/x86_64/" \
#    --mirror-on-sync "no"

# # add the Ansible repo.
# hammer repository create --organization-id 1 \
#     --product "CentOS 7 Linux x86_64" \
#     --name "Ansible x86_64" \
#     --label "Ansible_x86_64" \
#     --content-type "yum" \
#     --download-policy "on_demand" \
#     --gpg-key "RPM-GPG-KEY-CentOS-7" \
#     --url "http://mirror.centos.org/centos-7/7/configmanagement/x86_64/ansible29/" \
#     --mirror-on-sync "no"

# # a storage repository to setup Ceph
# hammer repository create --organization-id 1 \
#  --product "CentOS 7 Linux x86_64" \
#     --name "Storage x86_64" \
#     --label "Storage_x86_64" \
#     --content-type "yum" \
#     --download-policy "on_demand" \
#     --gpg-key "RPM-GPG-KEY-CentOS-7" \
#     --url "http://mirror.centos.org/centos-7/7/storage/x86_64/ceph-nautilus/" \
#     --mirror-on-sync "no"

# hammer repository list --organization-id 1 --product "CentOS 7 Linux x86_64"

# # Syncing the Contents
# hammer product list  --name "CentOS 7 Linux x86_64" --organization-id 1

# # Creating an Activation key
# hammer organization list
# # List the LifeCycle Environments
# hammer lifecycle-environment list
# # list the Content View
# hammer content-view list

# # create with separate activation key for development, testing and production
# # Activation Key for Development
# hammer activation-key create --organization-id 1 \
# --name "CentOS7_Dev" \
# --description "CentOS 7 Activation Key for Development/Test Servers" \
# --lifecycle-environment "Development" \
# --purpose-role "Red Hat Enterprise Linux Server" \
# --purpose-usage "Development/Test" \
# --content-view "CentOS 7" \
# --unlimited-hosts

# # Activation Key for Testing
# hammer activation-key create --organization-id 1 \
# --name "CentOS7_Tst" \
# --description "CentOS 7 Activation Key for Development/Test Servers" \
# --lifecycle-environment "Testing" \
# --purpose-role "Red Hat Enterprise Linux Server" \
# --purpose-usage "Development/Test" \
# --content-view "CentOS 7" \
# --unlimited-hosts

# # Activation Key for Production
# hammer activation-key create --organization-id 1 \
# --name "CentOS7_Prod" \
# --description "CentOS 7 Activation Key for Production Servers" \
# --lifecycle-environment "Production" \
# --purpose-role "Red Hat Enterprise Linux Server" \
# --purpose-usage "Production" \
# --content-view "CentOS 7" \
# --unlimited-hosts

# # List all created activation key from the command line for default organization “1“
# hammer activation-key list --organization-id 1

# # Adding Subscription to Activation Key
# # add the subscription into the created activation key
# hammer subscription list --organization-id 1
# # once anyone of server registered with katello server 
# # it will be assigned with respective Subscription and Repositories
# hammer activation-key add-subscription --organization-id 1 --name "CentOS7_Dev" --quantity "1" --subscription-id "1"
# hammer activation-key add-subscription --organization-id 1 --name "CentOS7_Tst" --quantity "1" --subscription-id "1"
# hammer activation-key add-subscription --organization-id 1 --name "CentOS7_Prod" --quantity "1" --subscription-id "1"