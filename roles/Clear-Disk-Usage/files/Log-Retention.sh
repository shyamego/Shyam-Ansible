#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
#############################################
#       Description: Applying Log Retention.
#       Author     : D.S Kumar
##############################################
DAYS_TO_KEEP=90
PROCESS_IDS_FILE=/tmp/process_ids.txt
PROCESS_FILE=/tmp/fileslist.txt
PROCESS_CATALINA_LOGS(){
        ps -ef | grep java | grep catalina | awk '{print $2}' > $PROCESS_IDS_FILE
        for TOMCAT_PID in `cat $PROCESS_IDS_FILE`
        do
        echo "******* Processing Tomcat Logs *******" >> $PROCESS_IDS_FILE
       #Find the catalina.out files being used by the process id
        TOMCAT_CATALINA_LOG_FILES=`/bin/lsof -p $TOMCAT_PID | awk '{if ( $9 ~ "catalina.out$" ) print $9}' |sort -n -u`
                for TOMCAT_LOG in $TOMCAT_CATALINA_LOG_FILES
                do
                TOMCAT_LOG_DIR=`dirname $TOMCAT_LOG`
                #Find the uncompressed catalina.out files and compress them
                find $TOMCAT_LOG_DIR -name "*.*-*-*" -mtime +1 -printf  "%p\n"  -exec gzip -v -q {} \; >> $PROCESS_IDS_FILE
                #Remove all *.gz files older then 90 Days
                #find $TOMCAT_LOG_DIR -name "*.*-*-*.gz" -mtime +${DAYS_TO_KEEP}  -printf "ls -lh %p; rm -vf %p\n" |bash >> $PROCESS_IDS_FILE
                done
        done
}
PROCESS_FILES(){
echo "******* Processing Files *******" >> $PROCESS_FILE
find / -xdev -type f -size +1G > $PROCESS_FILE
sed -i '/lastlog/d' /tmp/fileslist.txt
for FILE_PATH in `cat $PROCESS_FILE`
do
gzip $FILE_PATH
done
}
PROCESS_FILES
PROCESS_CATALINA_LOGS
