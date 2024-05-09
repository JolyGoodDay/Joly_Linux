#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path" # Ensures correct directory
source deactivate 2> /dev/null
source venv/bin/activate
python src/screenshot/screenshot.py