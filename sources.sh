#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: $0 [SRC_LOCATION] [PREFIX_TO_REMOVE]"
	exit 1;
fi

LOCATION=$1
REMOVE=$2

readarray -t FILES <<< "$(find $LOCATION -type f)"

for i in "${FILES[@]}"; do
	dirname=$(dirname $i)
	echo "<source-file src=\"$i\" target-dir=\"${dirname/$REMOVE/}\" />"
done
