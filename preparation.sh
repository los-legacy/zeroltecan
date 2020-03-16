#!/bin/bash
# Copyright (C) 2020 The Los-Legacy Open Source Project
# Mitch, Exodusnick, BenLue
set +xe
export PATH=~/bin:$PATH
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
cp -r "${SYSTEM_PATH}"/build_script/UniquePtr.h "${SYSTEM_PATH}"/libnativehelper/include/nativehelper/
