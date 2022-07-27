#!/bin/bash
set -e

source .env
k=reolink
PASS_FILE="--password-file=./pass.txt"
EXCLUDE="--exclude-file=exclude.txt"
INCLUDE="--files-from=include.txt"

export B2_ACCOUNT_ID=$B2_ID
export B2_ACCOUNT_KEY=$B2_KEY
restic -r b2:$B2_BUCKET:$BUCKET_DIR_NAME backup $INCLUDE $PASS_FILE $EXCLUDE > ${k}.log

./metrics.sh ./${k}.log type="\"drio-${k}\"" > metrics.$k
mv ./metrics.$k $NODE_EXPORTER_DIR/metrics.drio.${k}.prom
rm -f metrics.$k ${k}.log
