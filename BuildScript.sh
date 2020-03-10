#!/bin/bash
set -x
cd /home/benlue/android/lineage
export PATH=~/bin:$PATH
export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1
#repo sync --no-clone-bundle --force-sync
make clean;source build/envsetup.sh;breakfast zeroltecan;brunch zeroltecan
