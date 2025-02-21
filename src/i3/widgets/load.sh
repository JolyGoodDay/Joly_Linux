#!/bin/bash

# Get the first three load averages
load_avg=$(cat /proc/loadavg | cut -d' ' -f1-3)

# Get the number of CPUs
cpu_count=$(nproc)

if [[ $BLOCK_BUTTON == 3 ]]; then
    gnome-system-monitor --class "Widget_fs" --title "More detailed load information"
fi
if [[ $BLOCK_BUTTON == 2 ]]; then
    alacritty --class "Widget_fs" --title "More detailed load information" -e sh -c 'sh -c "journalctl -f"'
fi
if [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget" --title "More detailed load information" -e sh -c 'sh -c "top"'
fi
# Calculate the load averages per CPU and print them
echo "ᯓ $(echo $load_avg | awk -v cpu="$cpu_count" '{printf "%.2f %.2f %.2f", $1/cpu, $2/cpu, $3/cpu}')"
