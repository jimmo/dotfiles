#!/bin/sh

( (cd common && find . -type f) && ([ -d "$1" ] && cd $1 && find . -type f) ) | sort | uniq | while read file; do
  base=`echo $file | cut -d/ -f2`
  file=`echo $file | cut -d/ -f3-`
  prefix=""
  dest=""
  if [ $base = "etc" ]; then
    prefix="sudo "
    dest="/etc"
  fi
  if [ $base = "home" ]; then
    dest=$HOME
  fi
  $prefix mkdir -p `dirname $dest/$file`
  [ -e $dest/$file ] && $prefix bash -c "echo > $dest/$file"
  for part in common $1; do
    [ -e $part/$base/$file ] && $prefix bash -c "cat $part/$base/$file >> $dest/$file"
  done
done
