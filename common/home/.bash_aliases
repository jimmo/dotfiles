alias ll='ls -lhF'
alias la='ls -A'
alias lla='ls -lahF'
alias l='ls -CF'

alias les=less

alias :e=$EDITOR

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
