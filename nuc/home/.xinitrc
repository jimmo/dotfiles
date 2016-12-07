xset r rate 200 60
xset dpms 120 0 0

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

xscreensaver &

udiskie &

exec i3
