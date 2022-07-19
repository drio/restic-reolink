#!/bin/bash
set -e

dir=`dirname $0`

cd $dir
make backup forget
