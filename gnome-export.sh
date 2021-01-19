#!/bin/bash

echo > gnome-settings

for path in org/gnome/desktop/wm/keybindings org/gnome/desktop/wm/preferences org/gnome/desktop/peripherals/touchpad org/gnome/desktop/peripherals/keyboard org/gnome/shell/extensions/paperwm/keybindings; do
    dconf dump "/${path}/" | sed -e "s,^\[/\]$,[${path}],g" >> gnome-settings
done

# cat gnome-settings | dconf load /
