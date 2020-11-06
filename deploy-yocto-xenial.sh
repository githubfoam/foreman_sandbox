#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "============================build Yocto (Poky which is minimal development environment) =============================================================="

#  The purpose of the Yocto project is to create a Linux distro for manufacturers of embedded hardware and software.
#  A new minimal Linux distro will be created for qemu as the (qemu is a basic software emulator) target machine 
# run it in qemu

# Prerequisites for the development machine 
# Download latest Yocto (Poky which is minimal development environment) stable branch
apt-get update -qq
apt-get install -yqq wget git-core unzip make gcc g++ build-essential subversion \
sed autoconf automake texi2html texinfo coreutils diffstat python-pysqlite2 \
docbook-utils libsdl1.2-dev libxml-parser-perl libgl1-mesa-dev libglu1-mesa-dev \
xsltproc desktop-file-utils chrpath groff libtool xterm gawk fop

# the "morty" stable release of poky is cloned on the system.
git clone -b morty git://git.yoctoproject.org/poky.git

# Go inside the "poky" directory and 
# run the following command to set/export some variables for yocto development.
# after running the open embedded (oe) build environment script, 
# the path location in the terminal will be changed to a "build" directory for the further configuration 
# and compilation of new distribution
# cd poky && source oe-init-build-env

# "local.conf" file is created inside the "conf" directory.
# This is the configuration file for yocto which specifies details of the target machine and SDK for desired architecture etc.
# setting target machine "qemux86-64
# Uncomment following parameters in "local.conf"
# DL_DIR ?= "${TOPDIR}/downloads"
# SSTATE_DIR ?= "${TOPDIR}/sstate-cache"
# TMPDIR ?= "${TOPDIR}/tmp"
# PACKAGE_CLASSES ?= "package_rpm"
# SDKMACHINE ?= "i686"
# set a blank password for the Yocto based Linux and include the following parameters in the local.conf file
# Otherwise, the user will not be able to login in the new distro
# EXTRA_IMAGE_FEATURES ?= "debug-tweaks"
# not using any GUI tool such as toaster (hob is no more supported) to create Linux OS


# Yocto Compilation and Building Process
# run the following command of the bitbake utility to start the download 
# and compilation of packages for the selected target machine.
# as a normal Linux user and not the root user
# bitbake core-image-minimal