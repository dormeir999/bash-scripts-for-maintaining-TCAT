#!/bin/bash
TCAT_PATH=/var/www/dmi-tcat/
CRON_PATH=/var/spool/cron/crontabs/root
export PATH=$PATH:/bin:/usr/local/bin
echo Upgrading TCAT using instructions from https://github.com/digitalmethodsinitiative/dmi-tcat/wiki/Upgrading-TCAT
echo "Disable controller.php in your system's crontab"
cp $CRON_PATH $TCAT_PATH/root_backup_crontab
cp $TCAT_PATH/root_upgrade_crontab $CRON_PATH
read -p "Press [Enter] key to continue..."
echo Kill all running dmi-tcat processes
kill `/bin/ps -ef | grep php | egrep 'dmitcat|controller' | tr -s " " | cut -d' ' -f 2`
echo Remove all files in the proc/ directory
rm -f $TCAT_PATH/proc/*
read -p "Press [Enter] key to continue..."
echo Pull the latest code
git pull
echo Checking if the update completed:
git pull
read -p "Press [Enter] key to continue..."
echo Re-enable controller.php in your system crontab
cp $TCAT_PATH/root_backup_crontab $CRON_PATH
tail $CRON_PATH
read -p "Press [Enter] key to continue..."
echo Inspect the contents of controller.log
tail $TCAT_PATH/logs/controller.log
read -p "Press [Enter] key to continue..."
echo Upgrading database tables
/usr/bin/screen
/usr/bin/php $TCAT_PATH/common/upgrade.php
read -p "Press [Enter] key to continue..."
echo The TCAT upgrading has finished!
