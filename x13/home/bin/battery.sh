#!/bin/bash

while true; do
    r_s=`dbus-send --print-reply=literal --system --dest=org.freedesktop.UPower /org/freedesktop/UPower/devices/battery_BAT0 org.freedesktop.DBus.Properties.Get string:org.freedesktop.UPower.Device string:TimeToEmpty | awk '{ print  $3}'`
    if [ $r_s -ne 0 ]; then
        r_m=$(($r_s/60))
        if [ $r_m -lt 16 ]; then
            dunstify -a Battery "Battery Low" "$r_m mins remaining"
        fi
    fi
    sleep 60
done
