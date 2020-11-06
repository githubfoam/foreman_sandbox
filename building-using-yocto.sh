#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "============================Sample C Hello, world program=============================================================="

# Full Yocto OpenEmbedded environment is required for this tutorial
# https://variwiki.com/index.php?title=Yocto_Hello_World

# 4 Building using Yocto
# 4.1 Sample bitbake recipe of an "Hello, world!" application

# Create the following directory tree under your Yocto directory, 
# and place in it the two files described above
# sources/meta-variscite-fslc/recipes-examples/
# └── myhello
#     ├── files
#     │   └── myhello.c
#     └── myhello.bb


# 4.2 Build
# Run the following in your Yocto build directory 
# bitbake myhello

# To find the location of the output package 
# you can run the following in your Yocto build directory
# cd tmp/deploy/rpm && find -name myhello*

# To add the output of this recipe to your output images, 
# add the following to your conf/local.conf file in your Yocto build directory
# This will put the myhello app in your rootfs
# IMAGE_INSTALL_append = " myhello"
