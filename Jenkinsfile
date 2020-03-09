node('ben') {
   withEnv([
      'DEVICE=zeroltecan',    
      'LOS_PATH=/home/benlue/android/lineage',
      'LOCAL_MANIFESTS_URL=https://raw.githubusercontent.com/los-legacy/local_manifests/lineage-17.1/zero.xml', 
      'LOCAL_MANIFESTS_PATH=.repo/local_manifests', 
      'BRANCH=lineage-17.1'
   ]) {
      stage('Preparation') { // for display purposes
         sh "rm -rf $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/*"
         sh "wget $env.LOCAL_MANIFESTS_URL -O $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/zero.xml"
         sh "ls -lah $env.LOS_PATH/$env.LOCAL_MANIFESTS_PATH/"
      }
      stage('RepoSync') { // for display purposes
         //sh "cd $env.LOS_PATH; export PATH=~/bin:$PATH; repo sync --no-clone-bundle --force-sync"
      }
      stage('Build') { // for display purposes
         sh "set -x; cd $env.LOS_PATH; export PATH=~/bin:$PATH; source build/envsetup.sh; make clean; make lineage_zeroltecan"
      }
      stage('OTA Upload') { // for display purposes
         echo "Upload"
      }
   }
}
