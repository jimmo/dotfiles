alias ll='ls -lhF'
alias la='ls -A'
alias lla='ls -lahF'
alias l='ls -CF'

alias les=less

alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias vgrep='grep -v'
alias ergrep='grep -E -r'
alias vergrep='grep -v -E -r'
alias INFO='echo "INFO:"'
alias WARN='echo "WARN:"'

alias sharescreen='screen -x'
alias joinscreen='screen -x'
alias newscreen='screen -S'
alias createscreen='screen -S'
alias takescreen='screen -D -R'

alias scratch='cat > /dev/null'

alias agi='sudo apt-get install'
alias acs='apt-cache search'

function replace() {
  sed "s,$1,$2,g"
}

function field() {
  cut -d"$1" -f"$2"
}
function afield() {
  awk -F"$1" '{ print $'$2'}'
}

alias pwgens='pwgen -B -c -N 1 -n -y -s 12'

alias quoted='grep -o "\".*\"" | tr -d "\""'

alias linenumbers='awk "BEGIN { x=1; } { printf(\"%02d %s\n\", x, \$0); x+=1; }"'

alias total='awk "BEGIN { total=0.0; } { total+=\$1; } END { printf(\"%f\n\", total); }"'

function vimbuild() {
  if [ ! -p /tmp/vimbuild ]; then
    mkfifo /tmp/vimbuild
  fi
  while true; do cat /tmp/vimbuild > /dev/null; "$@"; echo Done.; echo; done
}

alias resudo='sudo $(history -p \!\!)'

function adb-screenshot() {
  # Takes a screenshot on the device and saves the resulting png locally.
  # Usage:
  # $ adb-n7
  # $ adb-screenshot [filename]
  file=screen-`date '+%Y%m%d-%H%M%S'`.png
  adb shell screencap -p /sdcard/$file
  adb pull /sdcard/$file ${1:-$file}
  adb shell rm /sdcard/$file
}

function adb-device() {
  # Sets ANDROID_SERIAL so all future adb invocations use that device.
  # Usage:
  # $ adb-device Device_Type
  # e.g. $ adb-device Nexus_7
  export ANDROID_SERIAL=`adb devices -l | grep -i $1 | awk '{print $1}'`;
}

# Handy wrappers for adb-device.
alias adb-n4="adb-device Nexus_4"
alias adb-n5="adb-device Nexus_5"
alias adb-n7="adb-device Nexus_7"

if [ -e ~/.bash_aliases.local ]; then
  source ~/.bash_aliases.local
fi

alias weather='curl http://wttr.in/sydney'
alias moon='curl http://wttr.in/Moon'
