
```
OSError(errno.ENOSPC, "inotify watch limit reached")
```
```
root@<hostname>:# cat /proc/sys/fs/inotify/max_user_instances
128
```
# How to Update `inotify` Limits: `max_user_instances` and `max_user_watches`

## Overview
The `inotify` system in Linux allows programs to monitor filesystem changes. However, default limits may be too low for applications that need to watch many files (e.g., development tools like Webpack or file synchronization services). This guide explains how to increase the limits for:

- `fs.inotify.max_user_instances`: The maximum number of inotify instances per user.
- `fs.inotify.max_user_watches`: The maximum number of files a user can monitor.

## Checking Current Limits
Before making changes, check the current values by running:

```bash
cat /proc/sys/fs/inotify/max_user_instances
cat /proc/sys/fs/inotify/max_user_watches
```

Update with (adjust new max as needed)
```
#!/bin/bash

new_max=524288

echo "==============================================="
echo "Updating inotify limits: max_user_instances and max_user_watches"
echo "==============================================="

# Update max_user_instances
echo ""
echo "Updating max_user_instances to ${new_max}..."
echo "Current value: $(cat /proc/sys/fs/inotify/max_user_instances)"
sudo sed -i '/^fs\.inotify\.max_user_instances\s*=/d' /etc/sysctl.conf
echo "fs.inotify.max_user_instances=${new_max}" | sudo tee -a /etc/sysctl.conf >/dev/null
sudo sysctl -p /etc/sysctl.conf
echo "Updated value: $(cat /proc/sys/fs/inotify/max_user_instances)"
echo "-----------------------------------------------"

# Update max_user_watches
echo ""
echo "Updating max_user_watches to ${new_max}..."
echo "Current value: $(cat /proc/sys/fs/inotify/max_user_watches)"
sudo sed -i '/^fs\.inotify\.max_user_watches\s*=/d' /etc/sysctl.conf
echo "fs.inotify.max_user_watches=${new_max}" | sudo tee -a /etc/sysctl.conf >/dev/null
sudo sysctl -p /etc/sysctl.conf
echo "Updated value: $(cat /proc/sys/fs/inotify/max_user_watches)"
echo "-----------------------------------------------"

echo "All changes applied successfully!"
echo "==============================================="

```
###

### systemd service file edits
```
[Service]
LimitNOFILE=524288
```