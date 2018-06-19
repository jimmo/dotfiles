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

    # Don't allow directories other than /etc and $HOME.
    if [ -z "$dest" ]; then
	echo "Not sure where to write $base"
	exit 1
    fi

    # Enable for debugging.
    #prefix="echo $prefix"

    # Create the temporary output file.
    echo -n > /tmp/dotfile

    # Prepend any '.prepend' files.
    for part in common $*; do
	[ -e $part/$base/$file.prepend ] && cat $part/$base/$file.prepend >> /tmp/dotfile
    done

    # Then the main content.
    for part in common $*; do
	[ -e $part/$base/$file ] && cat $part/$base/$file >> /tmp/dotfile
    done

    # Append any '.append' files.
    for part in common $*; do
	[ -e $part/$base/$file.append ] && cat $part/$base/$file.append >> /tmp/dotfile
    done

    if diff /tmp/dotfile $dest/$file > /dev/null; then
      echo "$dest/$file [skip]"
    else
      echo "$dest/$file [update]"
      $prefix mkdir -p `dirname $dest/$file`
      $prefix bash -c "cat /tmp/dotfile > $dest/$file"
    fi

    # Anything in bin/ gets +x.
    if [[ $file =~ ^bin/ ]]; then
	chmod +x $dest/$file
    fi
done

# Compile .emacs --> .emacs.elc
update_script=$PWD/update-emacs.el
(cd ~; emacs -nw -q --script $update_script)
