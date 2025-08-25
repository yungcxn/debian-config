#!/bin/sh
while true; do
  cpu=$(~/.config/cpu.sh)
  disk=$(~/.config/disk.sh)
  ram=$(~/.config/ram.sh)
  gpu=$(~/.config/gpu.sh)
  vol=$(~/.config/volume.sh)
  date=$(date '+%d.%m.%Y %H:%M')
  can="•—⟪==c==a==n===> "

  xsetroot -name "CPU: $cpu   Disk: $disk   RAM: $ram   GPU: $gpu   Vol: $vol   $date   $can"
  sleep 1
done
