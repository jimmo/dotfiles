xset r rate 200 60
xset dpms 120 0 0

# Workaround for bluetooth keyboard.
setxkbmap -option ctrl:nocaps

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

exec i3
