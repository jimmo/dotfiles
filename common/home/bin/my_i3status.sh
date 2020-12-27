#!/bin/sh
# shell script to prepend i3status with more stuff

XCLIP="xclip -o"
if [ -n $SWAYSOCK ]; then
    XCLIP="wl-paste -p"
fi

i3status | while read line; do
    export CLIP=`$XCLIP | cut -c1-20 | tr -d '\n'`
    echo $line | python3 -c '
import json
import os
line = input()
if line.startswith(",[{"):
    line = json.loads(line[1:])
    line.insert(0, {"name": "xclip", "full_text": "📋" + os.environ["CLIP"]})
    print("," + json.dumps(line))
else:
    print(line)
'
done
