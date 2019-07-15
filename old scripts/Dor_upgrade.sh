#!/bin/bash
export PATH=$PATH:/bin:/usr/local/bin
echo Upgrading TCAT using instructions from https://github.com/digitalmethodsinitiative/dmi-tcat/wiki/Upgrading-TCAT
echo "Disable controller.php in your system's crontab"
cp /var/spool/cron/crontabs/root /var/www/dmi-tcat/root_backup_crontab
cp /var/www/dmi-tcat/root_upgrade_crontab /var/spool/cron/crontabs/root
read -p "Press [Enter] key to continue..."
echo Kill all running dmi-tcat processes
kill `/bin/ps -ef | grep php | egrep 'dmitcat|controller' | tr -s " " | cut -d' ' -f 2`
echo Remove all files in the proc/ directory
rm -f /var/www/dmi-tcat/proc/*
read -p "Press [Enter] key to continue..."
echo Pull the latest code
git pull
echo Checking if the update completed:
git pull
read -p "Press [Enter] key to continue..."
echo Re-enable controller.php in your system crontab
cp /var/www/dmi-tcat/root_backup_crontab /var/spool/cron/crontabs/root
tail /var/spool/cron/crontabs/root
read -p "Press [Enter] key to continue..."
echo Inspect the contents of controller.log
tail /var/www/dmi-tcat/logs/controller.log
read -p "Press [Enter] key to continue..."
echo Upgrading database tables
/usr/bin/screen
/usr/bin/php /var/www/dmi-tcat/common/upgrade.php
read -p "Press [Enter] key to continue..."
echo The TCAT upgrading has finished!
