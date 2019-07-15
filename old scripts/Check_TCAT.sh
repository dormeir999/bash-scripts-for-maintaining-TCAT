#!/bin/bash
echo ====================TCAT STATUS CHECKUP=======================
read -a arr <<< `mysql --user=njohn --password=njohn -e "use information_schema; select table_name from tables where TABLE_NAME REGEXP 'tweets';" 2>/dev/null | grep tweets`
echo "The number of querybins is ${#arr[@]}"
for i in ${arr[@]}
do
   echo The number of tweets and last writing time of $i are:
   mysql --user=njohn --password=njohn -e "use twittercapture; select count(*) from $i;" 2>/dev/null 
   mysql --user=njohn --password=njohn -e "use information_schema; SELECT UPDATE_TIME FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = '$i';" 2>/dev/null 
done
echo ====================TCAT STATUS CHECKUP=======================

