#!/bin/bash

# Get the first three load averages
load_avg=$(cat /proc/loadavg | cut -d' ' -f1-3)

# Get the number of CPUs
cpu_count=$(nproc)

# Calculate the load averages per CPU and print them
echo "ᯓ $(echo $load_avg | awk -v cpu="$cpu_count" '{printf "%.2f %.2f %.2f", $1/cpu, $2/cpu, $3/cpu}')"
