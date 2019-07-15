#!/bin/bash
MAILBX=TCAT@mail.huji.ac.il
TCAT_PATH=/var/www/dmi-tcat/
BACKUP_PATH=/backup/
DRIVE_PATH=/usr/local/bin/drive
echo ====================TCAT Backup=======================
FILE=$BACKUP_PATH/alldata-$(date +"%d-%m-%Y").sql.gz
LOG=$BACKUP_PATH/logs/Backup-Checkup-log-$(date +"%d-%m-%Y").log
echo "" >>$LOG
date &>> $LOG
echo Starting backup: &>> $LOG
FILE=$BACKUP_PATH/alldata-$(date +"%d-%m-%Y").sql.gz
mysqldump --default-character-set=utf8mb4 -unjohn -pnjohn twittercapture | gzip > $FILE 2>> $LOG
echo Finished creating backup, named: $FILE. 
echo Uploading to drive: &>> $LOG
$DRIVE_PATH upload -f $FILE &>> $LOG
echo Finished uploading to drive. 
echo Removing old files: &>> $LOG
find $BACKUP_PATH -name "*.*.gz" -mtime +31 -exec rm {} \; &>> $LOG
find $BACKUP_PATH/logs -name "*.log" -mtime +31 -exec rm {} \; &>> $LOG
echo  The backup has ended. &>> $LOG
echo "" &>> $LOG
echo ====================TCAT Backup=======================
$TCAT_PATH/Check_TCAT.sh &>> $LOG
#/var/www/dmi-tcat/Check_TCAT.sh | mail -s "TCAT Checkup $(date +"%d-%m-%Y")" dor.meir999@gmail.com,tcat@mail.huji.ac.il
cat $LOG | mail -s "Backup & Checkup log of $(date +"%d-%m-%Y")" -A $LOG $MAILBX
