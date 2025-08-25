#!/bin/bash
# Disk usage in GB

# Choose the disk/partition to monitor, e.g., /
disk="/"

# Get disk usage info
if df_output=$(df -BG "$disk" | awk 'NR==2 {print $3, $2}' 2>/dev/null); then
  used=$(echo $df_output | awk '{print $1}' | sed 's/G//')
  total=$(echo $df_output | awk '{print $2}' | sed 's/G//')
  
  echo "$used/$total GB"
else
  echo "Disk info not available"
fi
