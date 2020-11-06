#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

# https://variwiki.com/index.php?title=Yocto_Hello_World
echo "============================build yocto release tag toolchain=============================================================="

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

# mkdir: cannot create directory ‘/home/travis/bin’: File exists
# mkdir ~/bin #(this step may not be needed if the bin folder already exists)
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

mkdir ~/var-fslc-yocto
cd ~/var-fslc-yocto

#choose between downloading a release tag, and downloading the latest revision (recommended) 

# Download a release tag
# Each release in https://github.com/varigit/variscite-bsp-platform/releases corresponds to a tag.
# The tags are also listed in https://github.com/varigit/variscite-bsp-platform/tags
# repo init -u https://github.com/varigit/variscite-bsp-platform.git -b refs/tags/morty-fslc-4.1.15-mx6ul-v1.0-beta

# Enable color display in this user account (y/N)?     
yes | repo init -u https://github.com/varigit/variscite-bsp-platform.git -b refs/tags/morty-fslc-4.1.15-mx6ul-v1.0-beta
repo sync -j4

# Yocto toolchain installation for out of Yocto builds
# https://variwiki.com/index.php?title=Yocto_Toolchain_installation&release=RELEASE_MORTY_BETA_DART-6UL
# To setup a Yocto build environment follow steps 1 & 3 of the Build Yocto from source code guide 
# and then proceed to either the toolchain or complete SDK steps below

# 2. Build a toolchain
cd ~/var-fslc-yocto
MACHINE=imx6ul-var-dart DISTRO=fslc-x11 . setup-environment build_x11

bitbake meta-ide-support
bitbake meta-toolchain

# 4. Install the toolchain/SDK
# Install the tools by running the resulted script in tmp/deploy/sdk/.
# The toolchain/script name depends on your build machine 
# and the bitbaked image/recipe, and may change
# Accept all the default options, and at the end of the installation you should see the following
# SDK has been successfully set up and is ready to be used.
tmp/deploy/sdk/fslc-x11-glibc-x86_64-meta-toolchain-armv7at2hf-neon-toolchain-2.2.1.sh

# 5. Use the toolchain/SDK
# Each time you wish to use the toolchain in a new shell session, 
# you need to source the environment setup script
source /opt/fslc-x11/2.2.1/environment-setup-armv7at2hf-neon-fslc-linux-gnueabi

# Full Yocto OpenEmbedded environment is required for this tutorial
# https://variwiki.com/index.php?title=Yocto_Hello_World

# 3 Building out of Yocto
# 3.1 Toolchain installation for out of Yocto builds
# 3.2 Build
# Now you should have an app called myhello, 
# that can be copied (using scp, for example) and run on your target board
CC myhello.c -o myhello

echo "============================build yocto release tag toolchain=============================================================="