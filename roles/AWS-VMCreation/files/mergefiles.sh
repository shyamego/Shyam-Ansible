#!/bin/bash
#########################################################
#  This script will concatenate multiplle .csv files    #
#  into one file 					#
#  Author: D.S Kumar 					#
# 							#
#########################################################

#for i in `ls /etc/ansible/IMP-FILES/*.csv`; do
#while read line
#do
#	echo $line >> /etc/ansible/IMP-FILES/OUTFILE/InfraInputValues.csv
#done < $i
#done
for i in `ls -1 /etc/ansible/IMP-FILES/*.*`
do
awk '{print}' $i >> /etc/ansible/IMP-FILES/OUTFILE/InfraInputValues.csv
done
