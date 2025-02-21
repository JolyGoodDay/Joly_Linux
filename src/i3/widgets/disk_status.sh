#!/bin/bash

# Colors for output
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Interactive mode when clicked
interactive_mode() {
    while true; do
        clear

        echo -e "${BLUE}### Mounted Devices ###${RESET}"
        lsblk

        echo -e "\n${CYAN}### Disk Usage Summary ###${RESET}"
        df -h --total

        echo -e "\nPress Ctrl+C to exit or q to quit."

        # Wait for the user to press a key
        read -n 1 -s key
        if [[ $key == "q" ]]; then
            break
        fi
    done
}

# Disk status for i3blocks
os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
disk_status="⛁"
disk_status+=" $(df -h / | awk '/\//{ printf("  %4s/%s \n", $4, $2) }')"
if [[ -d "/raid" ]]; then
  disk_status+=" ⛃ $(df -h /raid | awk '/\//{ printf("  %4s/%s \n", $4, $2) }')"
fi

# Handle i3blocks click event
if [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget" --title "Disk Usage Summary" -e bash -c "$(declare -f interactive_mode); interactive_mode"
fi

# Default output for i3blocks
echo $disk_status
