node('ben') {
    timestamps {
        withEnv([
            'DEVICE=zeroltecan',
            'BRANCH=lineage-17.1',
            'VERSION=17.1',
            'ROMTYPE=UNOFFICIAL',
            'OTA_ROMTYPE=unofficial',
            'SYSTEM_PATH=/home/benlue/android/lineage',
            'OUTPUT_PATH=/home/benlue/android/lineage/out/target/product',
            'URL=https://los-legacy.de',
            'LOCAL_MANIFESTS_URL=https://raw.githubusercontent.com/los-legacy/local_manifests/lineage-17.1/zero.xml',
            'LOCAL_MANIFESTS_PATH=.repo/local_manifests', 
    ]) {
    stage('Preparation') { // for display purposes
        sh """#!/bin/bash
            set +xe
            export PATH=~/bin:$PATH
            mkdir -p ~/bin
            curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
            chmod a+x ~/bin/repo
        """
    }
    stage('RepoSync') { // for display purposes
        echo "RepoSync process"
        sh """#!/bin/bash
            set +xe
            cd ${SYSTEM_PATH}
            export PATH=~/bin:$PATH
            git config --global user.name 'Jenkins'
            git config --global user.email 'jenkins@s3root.ovh'
            repo init -u https://github.com/LineageOS/android.git -b ${BRANCH}
            rm -rf ${SYSTEM_PATH}/${LOCAL_MANIFESTS_PATH}/*
            mkdir -p ${LOCAL_MANIFESTS_PATH}
            wget ${LOCAL_MANIFESTS_URL} -O ${SYSTEM_PATH}/${LOCAL_MANIFESTS_PATH}/zero.xml
            repo sync --no-clone-bundle --force-sync
        """
    }
    stage('Build') { // for display purposes
        echo "Build process"
        sh """#!/bin/bash
            set +xe
            cd ${SYSTEM_PATH}
            export PATH=~/bin:$PATH
            make clean
            source build/envsetup.sh
            export USE_CCACHE=1
            ccache -M 50G
            export CCACHE_COMPRESS=1
            breakfast ${DEVICE}
            brunch ${DEVICE}    
        """
    }
    stage('OTA Upload') { // for display purposes
        echo "OTA Upload process"
        sh '''#!/bin/bash
            set +xe
            DATETIME=$(date -u +"%F %H:%M:%S")
            if [ -z $@ ]; then
                export TARGET_DATE=$(date +"%Y%m%d");
            else
            export TARGET_DATE=$@;
            fi
            cd ${SYSTEM_PATH}
            echo "Erstelle MD5-Prüfsummmendatei"
            MD5SUM=$(cat ${OUTPUT_PATH}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip.md5sum | awk '{ print $1 }')
            FILESIZE=$(stat -c%s ${OUTPUT_PATH}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip )	    
            echo ""
            cat ${OUTPUT_PATH}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip.md5sum
            echo ""
            echo "Übertrage Rom in Datenbank"
            echo "URL: ${URL}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip"
            echo "Filename: ${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip"
            echo "Device: ${DEVICE}"
            echo "OS Version: ${VERSION}"
            echo "Datetime: $DATETIME"
            echo "Romtype: $OTA_ROMTYPE"
            echo "MD5SUM: $MD5SUM"
            echo "SIZE: $FILESIZE"
            NO_SUCCESS=1	
                while [ "$NO_SUCCESS" != "0" ]; do
                    scp ${OUTPUT_PATH}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip $USER@los-legacy.de:/var/www/html/files/$DEVICE/
            NO_SUCCESS=$?;
            done
            NO_SUCCESS=1
                while [ "$NO_SUCCESS" != "0" ]; do
                    scp ${OUTPUT_PATH}/${DEVICE}/${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip.md5sum $USER@los-legacy.de:/var/www/html/files/$DEVICE/
            NO_SUCCESS=$?;		
            done
            echo ""
            echo ""
            echo "Entferne ggfs. bereits eingetragenes Build von heute"
            echo "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask delrom -f ${BRANCH}-$DATETIME-${ROMTYPE}-${DEVICE}.zip"
            NO_SUCCESS=1
                while [ "$NO_SUCCESS" != "0" ]; do
                    ssh $USER@los-legacy.de "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask delrom -f ${BRANCH}-${TARGET_DATE}-${ROMTYPE}-${DEVICE}.zip"
            NO_SUCCESS=$?;
            done
            echo ""
            echo ""
            echo "Veröffentliche Build von heute"
            echo "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask addrom --filename ${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip --device $DEVICE --version $VERSION --datetime \""$DATETIME"\" --romtype $OTA_ROMTYPE --md5sum $MD5SUM --size "$FILESIZE" --url https://los-legacy.de/${DEVICE}/${BRANCH}-${TARGET_DATE}-${ROMTYPE}-${DEVICE}.zip"
            NO_SUCCESS=1
                while [ "$NO_SUCCESS" != "0" ]; do		
                    ssh $USER@los-legacy.de "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask addrom --filename ${BRANCH}-$TARGET_DATE-${ROMTYPE}-${DEVICE}.zip --device $DEVICE --version $VERSION --datetime \'"$DATETIME"\' --romtype $OTA_ROMTYPE --md5sum $MD5SUM --size "$FILESIZE" --url https://los-legacy.de/${DEVICE}/${BRANCH}-${TARGET_DATE}-${ROMTYPE}-${DEVICE}.zip"
            NO_SUCCESS=$?;	
            done
        '''
            }
        }
    }
}

