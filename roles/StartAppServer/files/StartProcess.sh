#!/bin/bash
echo -e "******* \tStarting The TOMCAT Process *******"
Startprocess=`find / -name startup.sh | grep tomcat`
$Startprocess
