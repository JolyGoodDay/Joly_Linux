#!/bin/bash

# Check if the block was clicked
if [[ "$BLOCK_BUTTON" == 1 ]]; then
    # Launch alacritty with a custom window title and run the show_all command in a loop
    alacritty --title "time/date interactive" -e bash ~/.config/i3/time_zone.sh
    exit 0
fi

TZ='America/Chicago' date '+%I:%M:%S %p'
