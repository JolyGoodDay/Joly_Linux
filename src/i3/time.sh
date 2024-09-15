#!/bin/bash

# Function to print the current time in the desired format
function times() {
    TZ='America/Chicago' date '+%I:%M:%S %p'
}

# Command to show additional information
show_all="clear; \
    echo 'blah'; \
    TZ="America/Chicago" date '+%I:%M:%S %p'; \
    echo "" \
    "

# Check if the block was clicked
if [[ "$BLOCK_BUTTON" == 1 ]]; then
    # Launch alacritty with a custom window title and run the show_all command in a loop
    alacritty --title "time/date interactive" -e bash -c 'while true; do '"$show_all"'; sleep .2; done'
    exit 0
fi

# Print the current time for the i3blocks status bar
times
