#!/bin/bash
STATUS=$(acpi -b | grep -v "Unknown")
PCT=$(echo "$STATUS" | grep -E -o '[0-9]+%' | tr -d '%' | awk '{s+=$1; n++} END {printf "%d%%", (n>0 ? s/n : 0)}')

PLUGGED=$(cat /sys/class/power_supply/AC*/online 2>/dev/null || cat /sys/class/power_supply/ADP*/online 2>/dev/null || echo 0)

if echo "$STATUS" | grep -q "Charging"; then
    echo "[+] $PCT"
elif [[ "$PLUGGED" == "1" ]]; then
    echo "[=] $PCT"
else
    echo "[ ] $PCT"
fi

if [[ $BLOCK_BUTTON == 1 ]]; then
    alacritty --class "Widget" --title "Battery" -e bash -c '
        while true; do
            clear
            acpi -b
            read -t 5 -n 1 key
            [[ "$key" == "q" ]] && break
        done
    '
fi
