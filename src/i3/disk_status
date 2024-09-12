os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
disk_status="⛁"
disk_status+=" $(df -h / | awk '/\//{ printf("  %4s/%s \n", $4, $2) }')"
if [[ -d "/raid" ]]; then
  disk_status+=" ⛃ $(df -h /raid | awk '/\//{ printf("  %4s/%s \n", $4, $2) }')"
fi
echo $disk_status