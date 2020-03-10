node('ben') {
   withEnv([
      'DEVICE=zeroltecan',    
      'LOS_PATH=/home/benlue/android/lineage',
      'LOCAL_MANIFESTS_URL=https://raw.githubusercontent.com/los-legacy/local_manifests/lineage-17.1/zero.xml',
      'BUILD_SCRIPT_URL=https://raw.githubusercontent.com/los-legacy/zeroltecan/lineage-17.1/BuildScript.sh',
      'LOCAL_MANIFESTS_PATH=.repo/local_manifests', 
      'BRANCH=lineage-17.1'
   ]) {
      stage('Preparation') { // for display purposes
         sh "rm -rf $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/*"
         sh "rm -rf $env.LOS_PATH/BuildScript.sh"
         sh "wget $env.LOCAL_MANIFESTS_URL -O $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/zero.xml"
         sh "wget $env.BUILD_SCRIPT_URL -O $env.LOS_PATH/BuildScript.sh"
         sh "ls -lah $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/"
      }
      stage('RepoSync') { // for display purposes
         //sh "cd $env.LOS_PATH; export PATH=~/bin:$PATH; repo sync --no-clone-bundle --force-sync"
      }
      stage('Build') { // for display purposes
         dir('/home/benlue/android/lineage') {
         sh'''#!/bin/bash
            export PATH=~/bin:$PATH
            export USE_CCACHE=1
            ccache -M 50G
            export CCACHE_COMPRESS=1
            make clean;source build/envsetup.sh;breakfast zeroltecan;brunch zeroltecan
         '''
         }
      }
      stage('OTA Upload') { // for display purposes
         echo "Upload"
      }
   }
}
