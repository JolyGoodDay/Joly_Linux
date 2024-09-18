#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path" # Ensures correct directory
echo $parent_path
gcc -shared -O3 -lX11 -fPIC -Wl,-soname,prtscn -o prtscn.so prtscn.c
python3.7 -m venv venv
source venv/bin/activate
pip install pillow xlib
python screenshot.py

#https://stackoverflow.com/questions/69645/take-a-screenshot-via-a-python-script-on-linux
