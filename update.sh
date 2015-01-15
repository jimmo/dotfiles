#!/bin/bash

for dir in common $*; do
  ([ -d "$dir" ] && cd $dir && find . -type f)
done | sort | uniq | while read file; do
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
  #prefix="echo $prefix"
  $prefix mkdir -p `dirname $dest/$file`
  [ -e $dest/$file ] && $prefix bash -c "echo > $dest/$file"
  for part in common $*; do
    [ -e $part/$base/$file ] && $prefix bash -c "cat $part/$base/$file >> $dest/$file"
  done
  if [[ $file =~ ^bin/ ]]; then
    chmod +x $dest/$file
  fi
done
