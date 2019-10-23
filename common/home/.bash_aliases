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

if [ -e /usr/bin/octave-cli ]; then
  alias octave="octave --no-gui"
fi

alias microscope='vlc v4l:// :v4l-vdev="/dev/video0"'

function github() {
  # TODO - convert http->ssh, and non-github.
  echo $1 | grep -E 'git@github.com:[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+.git' || return
  org=$(echo $1 | cut -d':' -f2 |  cut -d'/' -f1)
  proj=$(echo $1 | cut -d':' -f2 |  cut -d'/' -f2)
  proj=${proj%.git}
  mkdir -p ~/src/github.com/$org
  cd ~/src/github.com/$org
  git clone $1
  cd $proj
}

function microbit() {
  device=`lsblk -o NAME,VENDOR,MODEL | grep MBED | grep VFS | cut -d' ' -f1 | head -n1`
  if [ -z $device ]; then
    echo 'No micro:bit!'
    return
  fi
  cd `udisksctl mount -b /dev/$device | grep 'Mounted ' | grep -o '/run/media.*' | cut -c1- | sed 's/.$//g'`
}

function usbkey() {
  cd `udisksctl mount -b ${1:-/dev/sdb1} 2>&1 | grep 'ounted ' | grep -o '/run/media.*' | cut -c1- | sed "s/['.]*$//g"`
}

function unusbkey() {
  pwd | grep '/run/media/' && cd
  udisksctl unmount -b ${1:-/dev/sdb1}
}

function enter-venv() {
  if [ -d .venv ]; then
    source .venv/bin/activate
  elif [ -d venv ]; then
    source venv/bin/activate
  else
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
  fi
}

alias xilinx='source /opt/Xilinx/14.7/ISE_DS/settings64.sh'

alias pdf=google-chrome-stable
alias chrome=google-chrome-stable

alias ttyUSB='miniterm.py --raw /dev/ttyUSB0 115200'
alias ttyUSB1='miniterm.py --raw /dev/ttyUSB1 115200'
alias ttyUSB2='miniterm.py --raw /dev/ttyUSB1 115200'
alias ttyACM='miniterm.py --raw /dev/ttyACM0 115200'
alias ttyACM1='miniterm.py --raw /dev/ttyACM1 115200'
alias ttyACM2='miniterm.py --raw /dev/ttyACM2 115200'
alias u0='miniterm.py --raw /dev/ttyUSB0 115200'
alias u1='miniterm.py --raw /dev/ttyUSB1 115200'
alias u2='miniterm.py --raw /dev/ttyUSB1 115200'
alias a0='miniterm.py --raw /dev/ttyACM0 115200'
alias a1='miniterm.py --raw /dev/ttyACM1 115200'
alias a2='miniterm.py --raw /dev/ttyACM2 115200'

function find_gitignore() {
  if [ ${#1} -ge 10 ]; then
    echo 'No .gitignore found.'
    exit 1
  fi
  if [ -e "$1.gitignore" ]; then
    echo "$1.gitignore"
  else
    find_gitignore "../$1"
  fi
}

# Force ag to additionally a parent .gitignore.
alias agi='ag -p `find_gitignore ../`'

# Parallel make.
alias makep='make -j 16'
alias pmakep='make -j 16'
