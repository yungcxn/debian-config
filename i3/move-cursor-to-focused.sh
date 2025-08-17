#!/bin/bash

focused_window=$(xdotool getwindowfocus -f)
output=$(xdotool getwindowgeometry --shell $focused_window)

width=$(echo "$output" | awk -F= '/WIDTH/{print $2}')
height=$(echo "$output" | awk -F= '/HEIGHT/{print $2}')

if [[ "$width" -ne 1 || "$height" -ne 1 ]]; then
  move_x=$((width / 2))
  move_y=$((height / 2))
  xdotool mousemove --window "$focused_window" "$move_x" "$move_y"
fi
