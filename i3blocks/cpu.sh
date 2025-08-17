#!/usr/bin/env python3
import psutil

# One-time CPU usage display
blocks = "▁▂▃▄▅▆▇█"
cpu_data = psutil.cpu_percent(interval=0.1, percpu=True)
print("".join(blocks[min(int(usage/12.5), 7)] for usage in cpu_data))
