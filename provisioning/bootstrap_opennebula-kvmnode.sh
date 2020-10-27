#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

hostnamectl set-hostname opennebula-kvmnode
hostnamectl set-hostname opennebula-frontend
echo "192.168.50.23 opennebula-frontend.local opennebula-frontend" |sudo tee -a /etc/hosts
echo "192.168.50.24 opennebula-kvmnode.local opennebula-kvmnode" |sudo tee -a /etc/hosts
cat /etc/hosts
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

# update system with the latest available packages
apt-get update -yqq

# add OpenNebula repository to  OpenNebula front-end instance
# add the GPG key
wget -q -O- https://downloads.opennebula.org/repo/repo.key | apt-key add -

# add the repository
echo "deb https://downloads.opennebula.org/repo/5.12/Ubuntu/20.04 stable opennebula" | tee /etc/apt/sources.list.d/opennebula.list

# update the repository and install OpenNebula
apt-get update -yqq
apt-get install opennebula-node -yqq

cat /etc/libvirt/libvirtd.conf
