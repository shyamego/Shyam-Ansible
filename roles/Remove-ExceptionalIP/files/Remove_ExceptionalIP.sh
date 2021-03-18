#!/bin/bash
EXCEPTIONALLIST=/tmp/ExceptionalIP_List.csv
EXCEP_SVR_LIST=`cat $EXCEPTIONALLIST`

#Linux_File=/etc/ansible/scripts/Linux-hosts.csv
#Windows_File=/etc/ansible/scripts/Windows-hosts.csv
#>$Linux_File
#>$Windows_File

for i in $EXCEP_SVR_LIST
do
echo "inside...:$i"
sed -i -e 's/'$i'//g' /tmp/Main-inventory.csv
sed -i '/^$/d' /tmp/Main-inventory.csv
done
