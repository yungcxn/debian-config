#!/bin/bash
# GPU usage bars (NVIDIA)
if command -v nvidia-smi &> /dev/null; then
  info=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits)
  info=${info//,/ }
  read gpu mem_used mem_total <<< "$info"
  
  # Memory percentage
  mem_pct=$(( mem_used * 100 / mem_total ))
  
  # Create bars
  bar_length=8
  
  # GPU utilization bar
  gpu_filled=$(( gpu * bar_length / 100 ))
  gpu_empty=$(( bar_length - gpu_filled ))
  gpu_bar=$(printf "%0.s█" $(seq 1 $gpu_filled))$(printf "%0.s░" $(seq 1 $gpu_empty))
  
  # Memory bar
  mem_filled=$(( mem_pct * bar_length / 100 ))
  mem_empty=$(( bar_length - mem_filled ))
  mem_bar=$(printf "%0.s█" $(seq 1 $mem_filled))$(printf "%0.s░" $(seq 1 $mem_empty))
  
  echo "U:$gpu_bar$gpu% M:$mem_bar$mem_pct%"
else
  echo "No GPU"
fi