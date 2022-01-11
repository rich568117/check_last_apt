#!/bin/bash
cat /var/log/apt/history.log |grep -B 1 "apt-get upgrade" > /tmp/lastupgrade
awk 'BEGIN{FS=":";OFS=","}{$1=$1; print}' /tmp/lastupgrade > /tmp/lastupdate.csv
awk -F "\"*,\"*" '{print $2}' /tmp/lastupdate.csv > /tmp/lastaptupgrade.log
datum1=`date -d "$(cat /tmp/lastaptupgrade.log | head -1)" "+%s"`
datum2=`date "+%s"`

diff=$(($datum2-$datum1))

days=$(($diff/(60*60*24)))

echo $days
if [[ $days == 0 || $days < 30 ]]; then
        echo "OK - Last update was run less than 30 days ago"
        exit 0
        elif [ $days > 30 ]; then
                echo "CRITICAL - Over 30 days since last update!"
                exit 2
        else
                echo "UNKNOWN - Unable to calculate last update."
                exit 1
fi
