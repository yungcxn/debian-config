#!/bin/bash

prev=false
if [[ "$1" == "-p" ]]; then
  prev=true
fi

focused=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true)')
current_name=$(echo "$focused" | jq -r '.name')
output=$(echo "$focused" | jq -r '.output')

if [[ "$current_name" == "right" ]]; then
  i3-msg workspace "right2"
  exit
elif [[ "$current_name" == "right2" ]]; then
  i3-msg workspace "right"
  exit
fi

if [[ "$current_name" == "left" ]]; then
  i3-msg workspace "left2"
  exit
elif [[ "$current_name" == "left2" ]]; then
  i3-msg workspace "left"
  exit
fi

current_num=$(echo "$current_name" | grep -Eo '^[0-9]+')
workspaces=($(i3-msg -t get_workspaces | jq -r ".[] | select(.output==\"$output\") | .name" | sort -n))

for i in "${!workspaces[@]}"; do
  if [[ "${workspaces[$i]}" == "$current_name" ]]; then
    current_index=$i
    break
  fi
done

if $prev; then
  next_index=$(( (current_index - 1 + ${#workspaces[@]}) % ${#workspaces[@]} ))
else
  next_index=$(( (current_index + 1) % ${#workspaces[@]} ))
fi

i3-msg workspace "${workspaces[$next_index]}"
