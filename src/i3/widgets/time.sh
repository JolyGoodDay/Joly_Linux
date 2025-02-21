#!/bin/bash

time_zones() {
    declare -A timezones=(
        ["LA"]="America/Los_Angeles"
        ["TX"]="America/Chicago"
        ["EASTERN"]="America/New_York"
        ["UTC"]="UTC"
        ["LONDON"]="Europe/London"
        ["BERLIN"]="Europe/Berlin"
        ["MOSCOW"]="Europe/Moscow"
        ["TOKYO"]="Asia/Tokyo"
    )

    clear
    while true; do
        tput cup 0 0
        echo -e "\033[1;34mZone\t\t\t\tTime\033[0m"
        echo -e "\033[1;34m----\t\t\t\t----\033[0m"

        for zone in "LA" "TX" "EASTERN" "UTC" "LONDON" "BERLIN" "MOSCOW" "TOKYO"; do
            time=$(TZ="${timezones[$zone]}" date '+%a %Y-%m-%d %I:%M:%S %p')
            printf "\033[1;32m%-10s\033[0m          %s\n" "$zone" "$time"
        done

        echo -e "\nPress Ctrl+C to exit or q to quit."

        # Wait for 2 seconds or user input
        read -n 1 -t 2 -s key
        if [[ $key == "q" ]]; then
            break
        fi
    done
}

if [[ "$BLOCK_BUTTON" == 1 ]]; then
    alacritty --class "Widget" --title "time/date interactive" -e bash -c "$(declare -f time_zones); time_zones"
fi

# Default output for i3blocks
TZ='America/Chicago' date '+%I:%M:%S %p'
