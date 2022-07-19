#!/bin/bash
set -e

days=4
if [ ".$1" != "." ];then
  days=$1
fi

for d in basement driveway garden irongate;do
  find /home/reolink/$d -type d -ctime +"$days" -exec rm -rf {} \;
done
