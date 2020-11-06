#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

# https://variwiki.com/index.php?title=Yocto_Hello_World
echo "============================build yocto=============================================================="

# Yocto toolchain installation for out of Yocto builds
# https://variwiki.com/index.php?title=Yocto_Toolchain_installation&release=RELEASE_MORTY_BETA_DART-6UL

# DART-6UL - Yocto Morty 2.2.1 based on FSL Community BSP 2.2 with L4.1.15_2.0.0-ga Linux release
# https://variwiki.com/index.php?title=Yocto_Build_Release&release=RELEASE_MORTY_BETA_DART-6UL

# 1. Installing required packages
# make sure your host PC is running Ubuntu 14.04/ 64-bit and install the following packages
apt-get update -qq
apt-get install -yqq gawk wget git diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm

apt-get install -yqq autoconf libtool libglib2.0-dev libarchive-dev python-git \
sed cvs subversion coreutils texi2html docbook-utils python-pysqlite2 \
help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev \
mercurial automake groff curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv \
libncurses5 libncurses5-dev libncursesw5-dev libelf-dev zlib1g-dev bc

# 3. Download Yocto Morty based on Freescale Community BSP
git config --global user.name "githubfoam"
# git config --global user.email "githubfoam@githubfoam.com"

mkdir ~/bin #(this step may not be needed if the bin folder already exists)
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

mkdir ~/var-fslc-yocto
cd ~/var-fslc-yocto


echo "============================build yocto=============================================================="