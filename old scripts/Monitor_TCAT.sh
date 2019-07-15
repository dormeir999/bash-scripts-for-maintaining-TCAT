#!/bin/bash

# This is TCAT monitor scripts. it monitors the updating of the app, the controller log, the disk usage and the CPU and memory usage, and sends email to the designated mail boxes if anything is wrong.
# Updating Time Check
echo ""
echo "These are the current (`date +%b" "%d" "%T`) query bins updating times:"
/var/www/dmi-tcat/Check_TCAT.sh | grep -A2 "UPDATE_TIME" | grep ..:..:.. > /var/www/dmi-tcat/Current_UPDATING_TIMES.log
cat /var/www/dmi-tcat/Current_UPDATING_TIMES.log
Last_Check_time=`ls -l /var/www/dmi-tcat/Last_UPDAING_TIMES.log | cut -d" " -f 6-8`
echo ""
 echo "These are the last checkup ($Last_Check_time) query bins updating times:"
cat /var/www/dmi-tcat/Last_UPDAING_TIMES.log
echo ""
if cmp -s "/var/www/dmi-tcat/Current_UPDATING_TIMES.log" "/var/www/dmi-tcat/Last_UPDAING_TIMES.log"
then
   echo "TCAT is not updating... :("
   /var/www/dmi-tcat/Check_TCAT.sh | mail -s "TCAT is not UPDATING! " dor.meir999@gmail.com,TCAT@mail.huji.ac.il
else
   echo "TCAT is updating! :)"
fi
# Controller.log Check
 MESSAGE=`tail  -1 /var/www/dmi-tcat/logs/controller.log`
echo ""
if [[ $MESSAGE == *"the controller.php already running, skipping this check message"* ]]
then
echo "The controller.log is reporting 'the controller.php already running, skipping this check message'"
echo "TCAT is reporting 'the controller.php already running, skipping this check message'" | mail -s "There's a problem with TCAT" dor.meir999@gmail.com,TCAT@mail.huji.ac.il
else echo "The controller.log is reporting OK!"
fi
echo ""
# Disk Usage Check
echo "Checking Disk Usage:"
df -h
read -a arr <<< `df -h | grep -v Use | awk '{print $5}'`
for i in ${arr[@]}
	do
	if [ "$i" == "90%" ] ; then
		echo "There's a 90% usage in at least one disk! :("
		df -h | mail -s "There's a 90% usage of at least one disk!" dor.meir999@gmail.com,TCAT@mail.huji.ac.il
	fi
done

# CPU and Memory Check
echo ""
echo "Checking memory and CPU Usage:"
CPU=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
echo "The CPU usage is: $CPU%"
FREE_DATA=`free -m | grep Mem` 
CURRENT=`echo $FREE_DATA | cut -f3 -d' '`
TOTAL=`echo $FREE_DATA | cut -f2 -d' '`
RAM_PER=$(echo "scale = 2; $CURRENT/$TOTAL*100" | bc)
CPU_MORE_THEN_90=`echo "$CPU"'>'90 | bc -l`
MEM_MORE_THEN_90=`echo "$RAM_PER"'>'90 | bc -l`
echo "the RAM usage is: $RAM_PER%"
if  [[ "$CPU_MORE_THEN_90" = 1 ]] ; then
	echo "The CPU usage is more than 90%! :("
	top | mail -s "TCAT CPU usage is more then 90%" dor.meir999@gmail.com,TCAT@mail.huji.ac.il
	else echo "The CPU usage is less than 90% :)"
fi
if  [[ $MEM_MORE_THEN_90 = 1 ]]; then
	echo "The RAM usage is more than 90%! :("
	free -g | mail -s "TCAT memory usage is more then 90%" dor.meir999@gmail.com,TCAT@mail.huji.ac.il
	else echo "The RAM usage is less than 90% :)"
fi

 echo ====================TCAT UPDATE CHECKUP=======================
/var/www/dmi-tcat/Check_TCAT.sh | grep -A2 "UPDATE_TIME" | grep ..:..:.. > /var/www/dmi-tcat/Last_UPDAING_TIMES.log
