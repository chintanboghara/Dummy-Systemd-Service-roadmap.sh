#!/bin/bash

echo "Installing dummy systemd service..."
sleep 2

# Make the script executable
sudo chmod +x dummy.sh

# Create the directory if it doesn't exist
if [ ! -d /usr/bin/dummy/ ]; then
    sudo mkdir /usr/bin/dummy/
fi

# Copy the script to the directory
sudo cp dummy.sh /usr/bin/dummy/

# Copy the service file to systemd directory
sudo cp dummy.service /etc/systemd/system/

# Reload systemd daemon
sudo systemctl daemon-reload

echo "Dummy systemd service installed successfully!"

# Optional: Enable and start the service (uncomment to use)
# sudo systemctl enable dummy
# sudo systemctl start dummy
