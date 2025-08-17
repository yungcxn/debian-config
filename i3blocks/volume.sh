#!/bin/bash

# Get the default sink volume (0.0 - 1.0)
VOLUME_FLOAT=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')

# Check if muted
if wpctl get-volume @DEFAULT_SINK@ | grep -q "MUTED"; then
    echo "vol muted"
else
    # Convert to percentage
    VOLUME_PERCENT=$(echo "$VOLUME_FLOAT * 100 / 1" | bc)
    echo "vol: ${VOLUME_PERCENT}%"
fi
