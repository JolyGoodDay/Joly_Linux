#!/bin/bash

declare -A timezones=(
    ["LA"]="America/Los_Angeles"
    ["TX"]="America/Chicago"
    ["EASTERN"]="America/New_York"
    ["UTC"]="UTC"
)

clear
while true; do
    tput cup 0 0
    echo -e "\033[1;34mZone\t\t\t\tTime\033[0m"
    echo -e "\033[1;34m----\t\t\t\t----\033[0m"
    
    for zone in "LA" "TX" "EASTERN" "UTC"; do
        time=$(TZ="${timezones[$zone]}" date '+%a %Y-%m-%d %I:%M:%S %p')
        printf "\033[1;32m%-10s\033[0m          %s\n" "$zone" "$time"
    done
    
    sleep 2
done
