#!/bin/bash
window_count=$(i3-msg -t get_tree | jq '[.. | objects | select(.type=="workspace")] | map(select([.. | objects | select(.focused==true)] | length > 0)) | .[0] | [.. | objects | select(.window? and .window != null and .window_type != "unknown")] | length')

if [ "$window_count" -ne 0 ]; then
  current_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .name')

  if [ "$current_ws" = "right" ]; then
    i3-msg "workspace right2; exec $1"
  elif [ "$current_ws" = "right2" ]; then
    i3-msg "workspace right; exec $1"
  elif [ "$current_ws" = "left2" ]; then
    i3-msg "workspace left; exec $1"
  elif [ "$current_ws" = "left" ]; then
    i3-msg "workspace left; exec $1"
  else
    existing=$(i3-msg -t get_workspaces | jq '.[].num')

    if [ -n "$existing" ]; then
      next_ws=$(( $(echo "$existing" | sort -n | tail -n1) + 1 ))
    else
      next_ws=1
    fi

    i3-msg "workspace number $next_ws; exec $1"
  fi
else
  exec $1
fi
