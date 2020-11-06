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

# https://variwiki.com/index.php?title=Yocto_Build_Release&release=RELEASE_MORTY_BETA_DART-6UL
# 1 Installing required packages
# make sure your host PC is running Ubuntu 14.04/ 64-bit and install the following packages
apt-get update -qq
apt-get install -yqq gawk wget git diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping libsdl1.2-dev xterm

echo "============================build yocto=============================================================="