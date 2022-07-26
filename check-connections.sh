#!/bin/bash

CONNECTIONS_PORT=5901
LAST_ONLINE_FILE=/etc/vnc/.last_online
SHUTDOWN_DURATION=1800

echo ""
echo "#########################################"
echo "Started Script at $(date +"%x %X %z")"
echo "#########################################"
echo ""

CONNECTIONS=$(netstat -an | grep :$CONNECTIONS_PORT | grep ESTABLISHED | wc -l)
echo "THERE IS CURRENTLY $CONNECTIONS OPEN CONNECTION(S)"

if [ $CONNECTIONS == 0 ];
then
    NOW=$(date +"%s")
    echo "NOW = $NOW"
    LAST_ONLINE=$(stat -c %X $LAST_ONLINE_FILE)
    echo "LAST ONLINE = $LAST_ONLINE"
    DIFFERENCE=$(($NOW - $LAST_ONLINE))
    echo "WAS ONLINE FROM $DIFFERENCE SECONDS"
    if [ $DIFFERENCE -gt $SHUTDOWN_DURATION ]; 
    then
	echo " WILL SHUTDOWN in 1 minute"
        /sbin/shutdown -h +1
    else
        echo "WILL NOT SHUTDOWN"
    fi
else
    touch $LAST_ONLINE_FILE
fi

echo ""
echo "#######################################"
echo "Ended Script at $(date +"%x %X %z")"
echo "#######################################"
echo ""
