#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../src/common/set_joly_linux"


rm -rf ~/.config/i3
rm -rf ~/.i3
rm -rf ~/.config/i3status
rm -rf ~/.config/i3blocks

cp -r src/i3/ ~/.config/
i3-msg reload
i3-msg restart
