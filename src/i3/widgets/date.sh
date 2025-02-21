if [[ $BLOCK_BUTTON == 1 ]]; then
    # Launch alacritty with a custom window title
    alacritty --title "time/date interactive" --class "Widgets" -e sh -c 'sh -c "khal interactive"'
fi
echo "$(TZ='America/Chicago' date '+%a %Y-%m-%d')"
