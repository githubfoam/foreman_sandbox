#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname cobbler-server
echo "192.168.1.20 cobbler-server.local cobbler-server" |sudo tee -a /etc/hosts
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
yum -y install epel-release