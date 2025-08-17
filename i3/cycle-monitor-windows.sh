#!/bin/bash

current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')
echo "Current workspace: $current_workspace" >&2

mapfile -t windows < <(i3-msg -t get_tree | jq -r --arg ws "$current_workspace" '
  .. | objects | select(.type=="workspace" and .name==$ws) |
  .. | objects | select(.window? != null) | .id
')

echo "Found ${#windows[@]} windows: ${windows[*]}" >&2

if [ ${#windows[@]} -le 1 ]; then
echo "Need at least 2 windows to cycle" >&2
exit 1
fi

focused=$(i3-msg -t get_tree | jq -r '.. | objects | select(.focused?==true) | .id')
echo "Currently focused: $focused" >&2

current_index=-1
for i in "${!windows[@]}"; do
  if [[ "${windows[$i]}" == "$focused" ]]; then
    current_index=$i
    echo "Current index: $current_index of ${#windows[@]} windows" >&2
    break
  fi
done

if [ $current_index -eq -1 ]; then
  echo "Focused window not found in array, focusing first window" >&2
  i3-msg "[con_id=${windows[0]}] focus"
  exit 0
fi

total_windows=${#windows[@]}
next_index=$(( (current_index + 1) % total_windows ))

echo "Calculation: ($current_index + 1) % $total_windows = $next_index" >&2
echo "Will focus window ID: ${windows[$next_index]}" >&2

i3-msg "[con_id=${windows[$next_index]}] focus"
