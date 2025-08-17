#!/bin/bash
# RAM usage with a bar
read total used <<< $(free -m | awk '/Mem:/ {print $2,$3}')
percent=$(( used * 100 / total ))
bar_length=20
filled=$(( percent * bar_length / 100 ))
empty=$(( bar_length - filled ))
bar=$(printf "%0.s█" $(seq 1 $filled))$(printf "%0.s░" $(seq 1 $empty))
echo "$bar $used/$total MB ($percent%)"