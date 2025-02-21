#!/bin/bash

# Disable and stop cups.service
echo "Disabling and stopping cups.service..."
sudo systemctl stop cups.service
sudo systemctl disable cups.service

# Disable and stop cups.socket
echo "Disabling and stopping cups.socket..."
sudo systemctl stop cups.socket
sudo systemctl disable cups.socket

# Disable and stop cups.path
echo "Disabling and stopping cups.path..."
sudo systemctl stop cups.path
sudo systemctl disable cups.path

# Mask all CUPS-related units to prevent them from being started
echo "Masking cups.service, cups.socket, and cups.path..."
sudo systemctl mask cups.service
sudo systemctl mask cups.socket
sudo systemctl mask cups.path

# Verify the status of the units
echo "Checking the status of CUPS-related units..."
systemctl status cups.service cups.socket cups.path

echo "CUPS services and related units are now disabled and masked."
