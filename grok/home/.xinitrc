# Can't set repeat rate here for bt kbd as it loses config every
# time the keyboard re-connects. Set as Xserver option in /etc/X11/xdm/Xservers
# instead.
#xset r rate 200 60

xset dpms 120 0 0

# Workaround for bluetooth keyboard.
setxkbmap -option ctrl:nocaps

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

xscreensaver &

udiskie &

exec i3
