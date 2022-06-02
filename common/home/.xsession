# Note for BT keyboards:
# Can't set repeat rate here for a BT kbd as it loses config every
# time the keyboard re-connects.
# If using the BT keyboard again, with XDM you can pass flags to the X server using
# /etc/X11/xdm/Xservers
# :0 local /usr/bin/Xorg -ardelay 200 -arinterval 17 :0
# Also need to re-set ctrl:nocaps here in .xsession:
# setxkbmap -option ctrl:nocaps

xset r rate 200 60
xset dpms 600 0 0

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

#xscreensaver &

udiskie &
