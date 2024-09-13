#!/bin/bash
source /etc/environment
FILE="$joly_linux/tmp/alsa-scarlett-gui/src/"
if [[ $BLOCK_BUTTON == 1 ]]; then
    # Left click
    if [ -d "$FILE" ]; then
        cd $FILE
        ./alsa-scarlett-gui &
    fi
fi
cats=(
    "   ^•ﻌ•^    "
    "  ~^•ﻌ•^~   "
    " ~(=^･ω･^)~ "
    " (=^･ω･^=)  "
    " ~(=^‥^=)~  "
    "  (=^-ω-^=) "
    "  (=^･ｪ･^=) "
    " ~(=^･^=)~  "
    "  (=;ω;=)   "
    "   (•ㅅ•)   "
    "  (=ↀωↀ=)  "
    "  (=^･ｪ･^=) "
    "   (Ф∀Ф)    "
)

# Randomly pick a cat and echo it with a fixed width
random_index=$((RANDOM % ${#cats[@]}))
printf "%-12s\n" "${cats[$random_index]}"
