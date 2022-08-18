#!/usr/bin/bash

SECS=$1
LOG=$2
START=$(date "+%S")

while [ "$START" != "00" ]; do sleep 1; START=$(date "+%S"); echo $START; done
#while [ 1==1 ]; do echo -e ">>>>[$(date)]>>>>>>>>>>"; sleep 10; done
while [ 1==1 ]; do
	echo -e "====[$(date "+%Y%m%d_%T")]=========================================================" >>$LOG;
	sleep $SECS;
done

#====[20220817_20:42:27]=========================================================
