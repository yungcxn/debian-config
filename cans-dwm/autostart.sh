#!/bin/bash

dex --autostart --environment dwm &
nvidia-settings --load-config-only &
~/.config/i3/xrandr-bestpick.sh &
xcompmgr -n &
systemctl --user start xdg-desktop-portal.service &
xset s off &
xset -dpms &
nm-applet &
~/.config/default-bg.sh &
xinput --set-prop 12 "libinput Accel Speed" -0.75 &
setxkbmap -layout de_custom &
dunst &