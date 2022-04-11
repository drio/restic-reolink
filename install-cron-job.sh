#!/bin/bash

help() {
  cat<<EOF
Usage:
  $ install-cron-job.sh <when> <what>
Example:
  $ install-cron-job.sh "0 23,5 * * *" /tmp/script.sh
EOF
}

WHEN=$1
WHAT=$2

[ ".$WHEN" == "." ] && help
[ ".$WHAT" == "." ] && help

tmp=${TMPDIR:-/tmp}/xyz.$$
trap "rm -f $tmp; exit 1" 0 1 2 3 13 15
crontab -l | grep -v $WHAT > $tmp  # Capture crontab; delete old entry
echo "$WHEN $WHAT" >> $tmp
crontab < $tmp
rm -f $tmp
trap 0
