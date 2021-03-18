#!/bin/bash
###############################################
# This script will kill / stop the processes  #
# which will cause HIGH CPU Utilization       #
#                                             #
###############################################
>/tmp/pidcpuusage.txt
#>/tmp/cpu.txt
#top -n 1 -b  >> /tmp/cpu.txt
#CurrentUsage=`cat cpu.txt | head -1 | awk '{print $12}' | sed 's/[,]//g'`
Limit=6.10
ps -eo pid,ppid,%mem,%cpu,cmd --sort=-%cpu | awk '{print $1,$4,$5}' | sed '1d' >> /tmp/pidcpuusage.txt
sed -i '/python/d' /tmp/pidcpuusage.txt
#ps -eo pid,ppid,%mem,%cpu --sort=-%cpu | awk '{print $1,$4}' | sed '1d' >> /tmp/pidcpuusage.txt
PID_LIST=`cat /tmp/pidcpuusage.txt | awk '{print $1}'`
for i in $PID_LIST
do
PID_Usage=`grep $i /tmp/pidcpuusage.txt | awk '{print $2}'`
out=`bc -l <<< "$PID_Usage >= $Limit"`
if [[ $out == 1  ]];then
#echo " CPU Usage is HIGH $i for $PID_Usage"
PROSTRING=`ps -ef | grep $i | grep tomcat`
if grep -q "tomcat" <<< "$PROSTRING"; then
Stopprocess=`find / -name shutdown.sh | grep tomcat`
Startprocess=`find / -name startup.sh | grep tomcat`
echo -e "******* \tShutdowning The TOMCAT Process *******"
$Stopprocess
sleep 1m  #add check pid is down or not
echo -e "******* \tStarting The TOMCAT Process *******"
$Startprocess
sleep 5m
else
echo -e "******* \t Killing The  Process \t *******: $i"
kill -9 $i
fi
else
echo -e "******* \t CPU Usage Is Normal \t *******"
fi
done
