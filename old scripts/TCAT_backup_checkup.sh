#!/bin/bash
echo ====================TCAT Backup=======================
FILE=/backup/alldata-$(date +"%d-%m-%Y").sql.gz
LOG=/backup/logs/Backup-Checkup-log-$(date +"%d-%m-%Y").log
echo "" >>$LOG
date &>> $LOG
echo Starting backup: &>> $LOG
FILE=/backup/alldata-$(date +"%d-%m-%Y").sql.gz
mysqldump --default-character-set=utf8mb4 -unjohn -pnjohn twittercapture | gzip > $FILE 2>> $LOG
echo Finished creating backup, named: $FILE. 
echo Uploading to drive: &>> $LOG
/usr/local/bin/drive upload -f $FILE &>> $LOG
echo Finished uploading to drive. 
echo Removing old files: &>> $LOG
find /backup -name "*.*.gz" -mtime +31 -exec rm {} \; &>> $LOG
find /backup/logs -name "*.log" -mtime +31 -exec rm {} \; &>> $LOG
echo  The backup has ended. &>> $LOG
echo "" &>> $LOG
echo ====================TCAT Backup=======================
/var/www/dmi-tcat/Check_TCAT.sh &>> $LOG
#/var/www/dmi-tcat/Check_TCAT.sh | mail -s "TCAT Checkup $(date +"%d-%m-%Y")" dor.meir999@gmail.com,tcat@mail.huji.ac.il
cat $LOG | mail -s "Backup & Checkup log of $(date +"%d-%m-%Y")" -A $LOG TCAT@mail.huji.ac.il
