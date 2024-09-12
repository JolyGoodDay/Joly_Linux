#!/bin/bash
os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
config_file="$HOME/.config/i3/config"
#GTK Dark Mode

./usr/lib/gsd-xsettings
# Numlock
./usr/bin/numlockx on

# Fix screens
# exec_always xrandr --output DP-1 --scale 1x1
# exec_always xrandr --dpi 196

function set_font_pango_monospace() {
    sed -i "s/^.*font pango:monospace .*/font pango:monospace $1/" "$config_file"
    echo "Font size updated to $1 for $os_name"
}

function set_font_pango_sparkles() {
    sed -i "s/^.*font pango:Sparkles .*/font pango:Sparkles $1/" "$config_file"
    echo "Font size updated to $1 for $os_name"
}


if [ -f "$config_file" ]; then
    if [[ "$os_name" == "Ubuntu" ]]; then
        set_font_pango_monospace 14
        set_font_pango_sparkles 16

    elif [[ "$os_name" == "CentOS" ]]; then
        # If OS is CentOS, change font size to 12
        xrandr --screen 0 --output DP-6.1.8 --auto --right-of DP-6.8
        set_font_pango_monospace 10
        set_font_pango_sparkles 11

    else
        echo "Unsupported OS: $os_name"
    fi
else
    echo "$config_file file not found"
fi
