#!/bin/bash
# Copyright (C) 2020 The Los-Legacy Open Source Project
# Mitch, Exodusnick, BenLue
set +xe
cd "${SYSTEM_PATH}" || exit
export PATH=~/bin:$PATH
git config --global user.name 'Jenkins'
git config --global user.email 'jenkins@s3root.ovh'
repo init -u https://github.com/LineageOS/android.git -b ${BRANCH}
rm -rf "${SYSTEM_PATH:?}"/"${LOCAL_MANIFESTS_PATH}"/
mkdir -p "${LOCAL_MANIFESTS_PATH}"
wget "${LOCAL_MANIFESTS_URL}" -O "${SYSTEM_PATH}"/"${LOCAL_MANIFESTS_PATH}"/"${DEVICE}".xml
repo sync --no-clone-bundle --force-sync
