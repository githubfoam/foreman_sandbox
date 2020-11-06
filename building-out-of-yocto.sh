#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
# set -eox pipefail #safety for script

echo "============================Sample C Hello, world program=============================================================="

# Full Yocto OpenEmbedded environment is required for this tutorial
# https://variwiki.com/index.php?title=Yocto_Hello_World

# 3 Building out of Yocto
# 3.1 Toolchain installation for out of Yocto builds
# 3.2 Build
# Now you should have an app called myhello, 
# that can be copied (using scp, for example) and run on your target board
CC myhello.c -o myhello
