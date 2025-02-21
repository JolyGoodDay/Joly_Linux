ps aux | grep "wpa" | awk '{print $2}' | xargs -r sudo kill -9
