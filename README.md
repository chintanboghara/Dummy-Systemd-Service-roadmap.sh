# Dummy Systemd Service

This repository contains a simple, long-running systemd service that logs messages to both a file (`/var/log/dummy-service.log`) and the systemd journal. It’s designed as a learning tool to demonstrate creating, installing, and managing a systemd service on Linux.

## Features

- Runs continuously and restarts automatically if it fails.
- Logs to `/var/log/dummy-service.log` and the systemd journal.
- Supports standard `systemctl` commands for management.
- Includes installation and uninstallation scripts.

## Repository Structure

```
Dummy-Systemd-Service-roadmap.sh/
├── README.md          # This file
├── install.sh         # Installation script
├── uninstall.sh       # Uninstallation script
├── dummy.sh           # Script run by the service
└── dummy.service      # Systemd service file
```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/chintanboghara/Dummy-Systemd-Service-roadmap.sh.git
   cd Dummy-Systemd-Service-roadmap.sh
   ```

2. **Run the installation script**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   This will:
   - Make `dummy.sh` executable.
   - Create `/usr/bin/dummy/` if it doesn’t exist.
   - Copy `dummy.sh` to `/usr/bin/dummy/`.
   - Copy `dummy.service` to `/etc/systemd/system/`.
   - Reload the systemd daemon.

3. **Enable and start the service** (optional):
   ```bash
   sudo systemctl enable dummy
   sudo systemctl start dummy
   ```

## Usage

Manage the service with these commands:

- **Start the service**:
  ```bash
  sudo systemctl start dummy
  ```

- **Stop the service**:
  ```bash
  sudo systemctl stop dummy
  ```

- **Enable on boot**:
  ```bash
  sudo systemctl enable dummy
  ```

- **Disable on boot**:
  ```bash
  sudo systemctl disable dummy
  ```

- **Check status**:
  ```bash
  sudo systemctl status dummy
  ```

- **View logs in real-time (journal)**:
  ```bash
  sudo journalctl -u dummy -f
  ```

- **View log file**:
  ```bash
  tail -f /var/log/dummy-service.log
  ```

## Uninstallation

1. **Run the uninstallation script**:
   ```bash
   chmod +x uninstall.sh
   ./uninstall.sh
   ```

   This will:
   - Stop and disable the service.
   - Remove files from `/etc/systemd/system/` and `/usr/bin/dummy/`.
   - Delete `/var/log/dummy-service.log`.
   - Reload the systemd daemon.

## Notes

- **Path Choice**: The script is installed to `/usr/bin/dummy/`, which is unconventional. Consider `/usr/local/bin/` for custom scripts in a real deployment.
- **Permissions**: Runs as `root` to write to `/var/log/`. For security, use a dedicated user in production.
- **Journal Persistence**: Logs may not persist across reboots. Edit `/etc/systemd/journald.conf` and set `Storage=persistent` if needed.
