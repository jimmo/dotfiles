#!/bin/bash

# Get all the files that we're going to write.
# This is the union of all the paths in both 'common' and the specified host dirs.
for dir in common $*; do
    ([ -d "$dir" ] && find $dir -type f)
done | sort | uniq | grep -v '[.]prepend$' | while read file; do
    # 'base' is the top-level dir (e.g. 'home', 'etc').
    base=`echo $file | cut -d/ -f2`
    # 'file' is the path (e.g. '.i3/config', 'X11/xorg.conf.d/20-foo.conf').
    file=`echo $file | cut -d/ -f3-`

    # Optional prefix for running commands (e.g. 'sudo', or 'echo' for debugging).
    prefix=""
    dest=""

    # Things going in /etc need sudo.
    if [ $base = "etc" ]; then
	prefix="sudo "
	dest="/etc"
    fi

    # 'home' is $HOME
    if [ $base = "home" ]; then
	dest=$HOME
    fi
    
    if [ -z "$dest" ]; then
	echo "Not sure where to write $base"
	exit 1
    fi

    # Enable for debugging.
    #prefix="echo $prefix"

    # Create the destination directory.
    $prefix mkdir -p `dirname $dest/$file`
    # Create the destination file if it doesn't exist.
    [ -e $dest/$file ] && $prefix bash -c "echo > $dest/$file"

    # Prepend any '.prepend' files.
    for part in common $*; do
	[ -e $part/$base/$file.prepend ] && $prefix bash -c "cat $part/$base/$file.prepend >> $dest/$file"
    done

    # Then the main content.
    for part in common $*; do
	[ -e $part/$base/$file ] && $prefix bash -c "cat $part/$base/$file >> $dest/$file"
    done

    # Anything in bin/ gets +x.
    if [[ $file =~ ^bin/ ]]; then
	chmod +x $dest/$file
    fi
done
