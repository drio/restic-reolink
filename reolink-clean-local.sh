#!/bin/bash
set -e

days=4
if [ ".$1" != "." ];then
  days=$1
fi

find /home/pi/cameras -type d -ctime +"$days" -exec rm -rf {} \;
