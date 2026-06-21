#!/bin/bash
# Framework
BAT=$(acpi -b | grep -E -o '[1-9][0-9]?%' |tr '\n' ' ') 

echo "BAT: $BAT"
if [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget" --title "Battery" -e bash -c "acpi -b && sleep 60"
fi

