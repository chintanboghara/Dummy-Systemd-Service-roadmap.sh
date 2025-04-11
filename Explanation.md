This document explains the files in the Dummy Systemd Service repository: `install.sh`, `uninstall.sh`, `dummy.sh`, and `dummy.service`. These files work together to create, manage, and uninstall a simple systemd service that simulates a long-running process.

## 1. `dummy.sh`

### Purpose
This is the script executed by the systemd service. It runs continuously in the background, simulating a long-running application by printing a message every 10 seconds.

### Content
```bash
#!/bin/bash

while true; do
    echo "Dummy service is running..."
    sleep 10
done
```

### Explanation
- **Shebang (`#!/bin/bash`)**: Indicates that the script should be run using the Bash shell.
- **Infinite Loop (`while true; do ... done`)**: Keeps the script running indefinitely, mimicking a persistent service.
- **Log Message (`echo "Dummy service is running..."`)**: Prints a message to standard output (stdout) every iteration. This output is captured by systemd for logging, as configured in the service file.
- **Sleep (`sleep 10`)**: Pauses the script for 10 seconds between messages, preventing excessive resource use.

### Key Point
The script outputs to stdout rather than directly to a file. This allows systemd to handle the output, which can then be logged to both a file and the systemd journal, as defined in `dummy.service`.

## 2. `dummy.service`

### Purpose
This is the systemd service unit file that defines how `dummy.sh` is executed and managed by the systemd service manager.

### Content
```ini
[Unit]
Description=Dummy Systemd Service
After=network.target

[Service]
ExecStart=/bin/bash -c "/usr/bin/dummy/dummy.sh | tee /var/log/dummy-service.log"
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

### Explanation
- **[Unit] Section**:
  - `Description=Dummy Systemd Service`: A brief, human-readable description of the service.
  - `After=network.target`: Ensures the service starts after the network is available, though this is optional for this simple example.

- **[Service] Section**:
  - `ExecStart=/bin/bash -c "/usr/bin/dummy/dummy.sh | tee /var/log/dummy-service.log"`: The command to start the service.
    - `/bin/bash -c`: Executes the following command in a Bash shell.
    - `/usr/bin/dummy/dummy.sh`: Specifies the full path to the `dummy.sh` script.
    - `| tee /var/log/dummy-service.log`: Pipes the script’s stdout to `tee`, which writes it to `/var/log/dummy-service.log` and also forwards it to the systemd journal.
  - `Restart=always`: Ensures the service restarts automatically if it stops unexpectedly (e.g., due to a crash or manual termination).
  - `User=root`: Runs the service as the root user, required to write to `/var/log/dummy-service.log`. For production use, a less privileged user is recommended.

- **[Install] Section**:
  - `WantedBy=multi-user.target`: Indicates that the service should start when the system reaches the multi-user runlevel (normal boot state for most systems).

### Key Point
The `tee` command in `ExecStart` enables dual logging: output is saved to `/var/log/dummy-service.log` and remains accessible via `journalctl -u dummy -f` for real-time monitoring.

## 3. `install.sh`

### Purpose
This script automates the installation of the Dummy Systemd Service by copying files to the appropriate system directories and reloading the systemd daemon.

### Content
```bash
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
```

### Explanation
- **Initial Message and Sleep**: Displays a message to indicate the installation has started and pauses for 2 seconds for readability.
- **Make Script Executable**: Uses `chmod +x` to grant execute permissions to `dummy.sh`.
- **Create Directory**: Checks if `/usr/bin/dummy/` exists and creates it if not. Note that `/usr/local/bin/` might be a more conventional location for custom scripts.
- **Copy Files**: Copies `dummy.sh` to `/usr/bin/dummy/` and `dummy.service` to `/etc/systemd/system/`.
- **Reload Systemd**: Runs `systemctl daemon-reload` to refresh systemd’s configuration and recognize the new service.
- **Completion Message**: Confirms successful installation.
- **Optional Commands**: Includes commented-out lines to enable and start the service, which users can uncomment if desired.

### Key Point
This script streamlines setup by ensuring all files are correctly placed and systemd is updated, making the service ready to use.

## 4. `uninstall.sh`

### Purpose
This script stops the Dummy Systemd Service, removes its files from the system, and cleans up any associated resources.

### Content
```bash
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
```

### Explanation
- **Initial Message and Sleep**: Notifies the user that uninstallation is beginning and pauses for 2 seconds.
- **Stop and Disable Service**: Uses `systemctl stop` to halt the service and `systemctl disable` to prevent it from starting on boot.
- **Remove Files**: Deletes the service file from `/etc/systemd/system/`, the script directory from `/usr/bin/dummy/`, and the log file from `/var/log/dummy-service.log`.
- **Reload Systemd**: Runs `systemctl daemon-reload` to update systemd after removing the service file.
- **Completion Message**: Confirms successful uninstallation.

### Key Point
This script ensures a thorough cleanup, removing all traces of the service and its associated files from the system.

## Summary
- **`dummy.sh`**: A simple script that runs indefinitely, outputting messages to stdout every 10 seconds.
- **`dummy.service`**: The systemd unit file that controls the execution of `dummy.sh`, including logging to a file and the journal.
- **`install.sh`**: A helper script that installs the service by copying files and configuring systemd.
- **`uninstall.sh`**: A cleanup script that stops the service and removes all related files.
