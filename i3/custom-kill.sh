#!/bin/bash

# Find the number of windows on the currently focused workspace
window_count=$(i3-msg -t get_tree | jq '[.. | objects | select(.type=="workspace")] | map(select([.. | objects | select(.focused==true)] | length > 0)) | .[0] | [.. | objects | select(.window? and .window != null and .window_type != "unknown")] | length')

if [ "$window_count" -eq 1 ] || [ "$window_count" -eq 0 ]; then
  i3-msg kill
  ~/.config/i3/next-workspace.sh
else
  i3-msg kill
fi