#!/bin/bash
os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
config_file="$HOME/.config/i3/config"
#GTK Dark Mode

# Ensure GTK configuration directory and file exist
mkdir -p ~/.config/gtk-3.0
if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
    echo '[Settings]' > ~/.config/gtk-3.0/settings.ini
fi
if ! grep -q 'gtk-theme-name = Adwaita-dark' ~/.config/gtk-3.0/settings.ini; then
    echo 'gtk-theme-name = Adwaita-dark' >> ~/.config/gtk-3.0/settings.ini
fi

# Ensure QT configuration directory and file exist
mkdir -p ~/.config/qt5ct
if [ ! -f ~/.config/qt5ct/qt5ct.conf ]; then
    echo '[Appearance]' > ~/.config/qt5ct/qt5ct.conf
fi
if ! grep -q 'style=gtk2' ~/.config/qt5ct/qt5ct.conf; then
    echo 'style=gtk2' >> ~/.config/qt5ct/qt5ct.conf
    echo 'palette=qt5ct' >> ~/.config/qt5ct/qt5ct.conf
fi

# Ensure .Xresources file exists and add URxvt theme if not already present
if [ ! -f ~/.Xresources ]; then
    touch ~/.Xresources
fi
if ! grep -q 'URxvt.background: black' ~/.Xresources; then
    echo 'URxvt.background: black' >> ~/.Xresources
    echo 'URxvt.foreground: white' >> ~/.Xresources
    xrdb ~/.Xresources
fi

# Ensure Alacritty configuration directory and file exist
mkdir -p ~/.config/alacritty
if [ ! -f ~/.config/alacritty/alacritty.yml ]; then
    touch ~/.config/alacritty/alacritty.yml
fi
if ! grep -q 'background: "0x1d1f21"' ~/.config/alacritty/alacritty.yml; then
    echo 'colors:' > ~/.config/alacritty/alacritty.yml
    echo '  primary:' >> ~/.config/alacritty/alacritty.yml
    echo '    background: "0x1d1f21"' >> ~/.config/alacritty/alacritty.yml
    echo '    foreground: "0xc5c8c6"' >> ~/.config/alacritty/alacritty.yml
fi
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
    source /etc/os-release
    if [[ "$os_name" == "Ubuntu" ]]; then
        set_font_pango_monospace 14
        set_font_pango_sparkles 16

    elif [[ "$ID" == "centos" ]]; then
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

