#!/bin/bash
BASE=/tmp/Main-inventory.csv
SVR_LIST=`cat $BASE | sort -u`
Linux_File=/tmp/Linux-hosts.csv
Windows_File=/tmp/Windows-hosts.csv
>$Linux_File
>$Windows_File
for i in $SVR_LIST
do
LINUXHOSTNAME=`nmap -O -v -sT $i  | awk  '{print $3}' | sed '1d' | grep ssh`
WINDOWSHOSTNAME=`nmap -O -v -sT $i | awk  '{print $3}' | sed '1d' | grep microsoft-ds`
if  [[ $LINUXHOSTNAME == "ssh" ]] && [ -z "$WINDOWSHOSTNAME" ]; then
echo "$i" >> $Linux_File
fi
if [ "$WINDOWSHOSTNAME" == "microsoft-ds" ] && [ "$LINUXHOSTNAME" == "ssh" ]; then 
echo "$i" >> $Windows_File
fi
if [ "$WINDOWSHOSTNAME" == "microsoft-ds" ]  && [ -z "$LINUXHOSTNAME" ]; then
echo "$i" >> $Windows_File
fi
if [ -z "$LINUXHOSTNAME" ] && [ -z "$WINDOWSHOSTNAME" ]; then
echo " $i Not in use"
fi
done
