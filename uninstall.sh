#!/bin/bash

echo "Stopping and uninstalling dummy systemd service..."
sleep 2

# Stop and disable the service
sudo systemctl stop dummy.service
sudo systemctl disable dummy.service

# Remove the service file
sudo rm /etc/systemd/system/dummy.service

# Remove the script directory
sudo rm -rf /usr/bin/dummy/

# Remove the log file
sudo rm /var/log/dummy-service.log

# Reload systemd daemon
sudo systemctl daemon-reload

echo "Dummy systemd service stopped and uninstalled successfully!"
