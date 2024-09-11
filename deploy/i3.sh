#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path" # Ensures correct directory
cd ../src
ls
rm -rf ~/.config/i3
rm -rf ~/.i3
rm -rf ~/.config/i3status
rm -rf ~/.config/i3blocks

cp -r i3/ ~/.config/
i3-msg reload
i3-msg restart
