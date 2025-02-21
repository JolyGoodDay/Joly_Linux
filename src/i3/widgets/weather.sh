#!/bin/bash

interactive_mode() {
    # Create temp directory if it doesn't exist
    CACHE_DIR="/tmp/i3/wttr"
    mkdir -p "$CACHE_DIR"

    # Generate cache file path based on URL
    get_cache_file() {
        local url="$1"
        echo "$CACHE_DIR/$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g')"
    }

    # Fetch weather and save to cache if outdated
    fetch_weather() {
        local url="$1"
        local cache_file
        cache_file=$(get_cache_file "$url")

        if [ -f "$cache_file" ]; then
            local last_modified
            last_modified=$(date -r "$cache_file" +%s)
            local current_time
            current_time=$(date +%s)
            local age
            age=$((current_time - last_modified))

            if [ $age -lt 120 ]; then
                return
            fi
        fi

        local output
        output=$(curl -s "$url")
        if [ $? -eq 0 ]; then
            echo "$output" > "$cache_file"
        fi
    }

    # Display cached output or fetch if unavailable
    display_weather() {
        local url="$1"
        local cache_file
        cache_file=$(get_cache_file "$url")

        if [ -f "$cache_file" ]; then
            clear
            cat "$cache_file"
        fi
        echo -e "\nPress Ctrl+C to exit or q to quit."
    }

    local mode="$1"
    local url
    trap "clear; echo 'Exiting...'; exit 0" SIGINT SIGTERM

    while true; do
        case "$mode" in
            3) url="https://wttr.in/moon" ;;
            2) echo "Enter a ZIP code:"; read -p "> " zip; url="https://wttr.in/$zip";;
            *) url="https://wttr.in/78602";; # Bastrop, Texas
        esac

        fetch_weather "$url" &
        display_weather "$url"

        for ((i = 0; i < 60; i++)); do
            read -t 1 -n 1 key
            if [[ $key == "q" ]]; then
                clear
                echo "Exiting..."
                exit 0
            fi
        done
    done
}

# Handle i3blocks click event
if [[ $BLOCK_BUTTON == 3 ]]; then
    alacritty --class "Widget_mid" --title "Moon Summary" -e bash -c "$(declare -f interactive_mode); interactive_mode 3"
elif [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget_mid" --title "Weather Summary" -e bash -c "$(declare -f interactive_mode); interactive_mode 1"
elif [[ $BLOCK_BUTTON == 2 ]]; then
    alacritty --class "Widget_mid" --title "Custom ZIP Weather" -e bash -c "$(declare -f interactive_mode); interactive_mode 2"
fi

# Default output to i3blocks
curl -Ss 'https://wttr.in/78602?format=%C+%t+%w' | xargs echo
