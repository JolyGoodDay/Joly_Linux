#

#!/bin/bash


interactive_mode() {
    while true; do
        clear
        echo "Public Info"
        curl -s ipinfo.io | jq

        echo -e "\nPress Ctrl+C to exit or q to quit."

        # Wait for the user to press a key
        read -n 1 -s key
        if [[ $key == "q" ]]; then
            break
        fi
    done
}

# Handle i3blocks click event
if [[ $BLOCK_BUTTON == 2 ]]; then
    alacritty --class "Widget" --title "Disk Usage Summary" -e bash -c "$(declare -f interactive_mode); interactive_mode"
fi

ifconfig eth0 | grep 'inet ' | awk '{print "E: "$2}'
