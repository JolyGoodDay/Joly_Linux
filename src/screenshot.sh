#!/bin/bash
source /etc/environment
cd "$parent_path" # Ensures correct directory
source deactivate 2> /dev/null
source venv/bin/activate
python src/screenshot/screenshot.py
