#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../src/common/set_joly_linux"


rm -rf ~/.config/i3
rm -rf ~/.i3
rm -rf ~/.config/i3status
rm -rf ~/.config/i3blocks
rm -rf  ~/.config/alacritty/
rm -rf ~/.config/khal

cp -r src/i3/ ~/.config/
cp -r src/alacritty/ ~/.config/
cp -r src/khal/ ~/.config/
i3-msg reload
i3-msg restart
