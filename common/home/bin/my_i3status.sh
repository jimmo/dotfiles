#!/bin/sh
# shell script to prepend i3status with more stuff

i3status | while read line; do
    export CLIP=`xclip -o | cut -c1-20 | tr -d '\n'`
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
