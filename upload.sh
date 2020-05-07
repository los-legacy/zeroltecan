#!/bin/bash
# Copyright (C) 2020 The Los-Legacy Open Source Project
# Mitch, Exodusnick, BenLue
set +xe
cd "${SYSTEM_PATH}" || exit

echo "$OUTPUT_PATH"
echo "$FILENAME"

if [ -e "$OUTPUT_PATH"/"$FILENAME"  ]; then
  echo "Starte Upload"  
else
    ls "$OUTPUT_PATH"/"$FILENAME"
fi

if [ -e "$OUTPUT_PATH"/"$FILENAME" ]; then
  
  echo "Erstelle MD5-Prüfsummmendatei"
  
  BUILD_DATE=$(date -r "${OUT}"/build_date.txt "+%Y%m%d")
  MD5SUM=$(cat < "${OUTPUT_PATH}"/"${DEVICE}"/"${BRANCH}"-"${BUILD_DATE}"-"${ROMTYPE}"-"${DEVICE}".zip.md5sum | awk '{ print $1 }')
  FILESIZE=$(stat -c%s "${OUTPUT_PATH}"/"${DEVICE}"/"${BRANCH}"-"${BUILD_DATE}"-"${ROMTYPE}"-"${DEVICE}".zip )       
  DATETIME=$(date -r "${OUT}"/build_date.txt "+%F %H:%M:%S")
  
  echo ""
  cat "${OUTPUT_PATH}"/"${DEVICE}"/"${BRANCH}"-"${BUILD_DATE}"-"${ROMTYPE}"-"${DEVICE}".zip.md5sum
  echo ""
  echo "Übertrage Rom in Datenbank"
  echo "URL: ${URL}/${DEVICE}/${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip"
  echo "Filename: ${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip"
  echo "Device: ${DEVICE}"
  echo "OS Version: ${VERSION}"
  echo "Datetime: $DATETIME"
  echo "Romtype: $OTA_ROMTYPE"
  echo "MD5SUM: $MD5SUM"
  echo "SIZE: $FILESIZE"
   
  NO_SUCCESS=1  
    while [ "$NO_SUCCESS" != "0" ]; do
      scp "${OUTPUT_PATH}"/"${DEVICE}"/"${BRANCH}"-"${BUILD_DATE}"-"${ROMTYPE}"-"${DEVICE}".zip "$USER"@"$SSH_URL":/var/www/html/files/"$DEVICE"/
      NO_SUCCESS=$?;
    done
    NO_SUCCESS=1
    while [ "$NO_SUCCESS" != "0" ]; do
      scp "${OUTPUT_PATH}"/"${DEVICE}"/"${BRANCH}"-"${BUILD_DATE}"-"${ROMTYPE}"-"${DEVICE}".zip.md5sum "$USER"@"$SSH_URL":/var/www/html/files/"$DEVICE"/
      NO_SUCCESS=$?;        
    done
    echo ""
    echo "Entferne ggfs. bereits eingetragenes Build von heute"
    echo "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask delrom -f ${BRANCH}-$DATETIME-${ROMTYPE}-${DEVICE}.zip"
    NO_SUCCESS=1
    while [ "$NO_SUCCESS" != "0" ]; do
      ssh "$USER"@"$SSH_URL" "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask delrom -f \${BRANCH}-\${BUILD_DATE}-\${ROMTYPE}-\${DEVICE}.zip"
      NO_SUCCESS=$?;
    done
    echo ""
    echo "Veröffentliche Build von heute"
    echo "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask addrom --filename ${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip --device $DEVICE --version $VERSION --datetime \"""$DATETIME""\" --romtype $OTA_ROMTYPE --md5sum $MD5SUM --size ""$FILESIZE"" --url ${URL}/${DEVICE}/${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip"
    NO_SUCCESS=1
    while [ "$NO_SUCCESS" != "0" ]; do      
      ssh $USER@los-legacy.de "cd /opt/lineageos_updater && FLASK_APP=/opt/lineageos_updater/app.py flask addrom --filename ${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip --device $DEVICE --version $VERSION --datetime \""$DATETIME"\" --romtype $OTA_ROMTYPE --md5sum $MD5SUM --size "$FILESIZE" --url https://los-legacy.de/${DEVICE}/${BRANCH}-${BUILD_DATE}-${ROMTYPE}-${DEVICE}.zip"
      NO_SUCCESS=$?;    
    done
fi
