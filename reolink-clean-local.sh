#!/bin/bash
set -e

for d in basement driveway garden irongate;do
  find /home/reolink/$d -type d -ctime +4 -exec rm -rf {} \;
done
