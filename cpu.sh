#!/usr/bin/env python3
import psutil
import os
import subprocess

# One-time CPU usage display
blocks = "▁▂▃▄▅▆▇█"
cpu_data = psutil.cpu_percent(interval=0.1, percpu=True)
result = subprocess.run(
  "sensors | awk '/Core 0:/ {print $3}'", 
  shell=True, 
  capture_output=True, 
  text=True
)

print("".join(blocks[min(int(usage/12.5), 7)] for usage in cpu_data) + " [" + result.stdout.strip() + "]")
