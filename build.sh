#!/bin/bash
# Copyright (C) 2020 The Los-Legacy Open Source Project
# Mitch, Exodusnick, BenLue
set +xe
cd "${SYSTEM_PATH}" || exit
export PATH=~/bin:$PATH
make clean
source build/envsetup.sh
export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1
breakfast "${DEVICE}"; brunch "${DEVICE}"
