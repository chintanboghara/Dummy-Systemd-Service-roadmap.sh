# Dummy Systemd Service

This repository provides a simple, long-running systemd service designed as a learning tool. The service logs messages to both `/var/log/dummy-service.log` and the systemd journal, demonstrating how to create, install, and manage a systemd service on Linux.

## Features

- **Continuous Operation:** Runs continuously and automatically restarts on failure.
- **Dual Logging:** Logs output to a log file (`/var/log/dummy-service.log`) and the systemd journal.
- **Standard Management:** Supports standard `systemctl` commands for starting, stopping, and status monitoring.
- **Easy Setup:** Comes with installation and uninstallation scripts for quick deployment.

## Repository Structure

```plaintext
Dummy-Systemd-Service-roadmap.sh/
├── README.md          # Project overview and instructions
├── install.sh         # Installation script
├── uninstall.sh       # Uninstallation script
├── dummy.sh           # Script executed by the service
└── dummy.service      # Systemd service unit file
```

## Installation

### 1. Clone the Repository

Clone the repository to your local machine and change into the project directory:

```bash
git clone https://github.com/chintanboghara/Dummy-Systemd-Service-roadmap.sh.git
cd Dummy-Systemd-Service-roadmap.sh
```

### 2. Run the Installation Script

Make the installation script executable and run it:

```bash
chmod +x install.sh
./install.sh
```

The script will:
- Set executable permissions on `dummy.sh`.
- Create `/usr/bin/dummy/` if it does not already exist.
- Copy `dummy.sh` to `/usr/bin/dummy/`.
- Copy `dummy.service` to `/etc/systemd/system/`.
- Reload the systemd daemon to apply changes.

### 3. (Optional) Enable and Start the Service

To enable the service to start on boot and start it immediately, run:

```bash
sudo systemctl enable dummy
sudo systemctl start dummy
```

## Usage

Once installed, you can manage the service using standard systemd commands. Here are some common operations:

- **Start the Service:**

  ```bash
  sudo systemctl start dummy
  ```

- **Stop the Service:**

  ```bash
  sudo systemctl stop dummy
  ```

- **Enable the Service on Boot:**

  ```bash
  sudo systemctl enable dummy
  ```

- **Disable the Service on Boot:**

  ```bash
  sudo systemctl disable dummy
  ```

- **Check the Service Status:**

  ```bash
  sudo systemctl status dummy
  ```

- **View Real-Time Logs (Journal):**

  ```bash
  sudo journalctl -u dummy -f
  ```

- **View the Log File:**

  ```bash
  tail -f /var/log/dummy-service.log
  ```

## Uninstallation

To remove the service, run the provided uninstallation script:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

This script will:
- Stop and disable the service.
- Remove the service file from `/etc/systemd/system/` and the executable from `/usr/bin/dummy/`.
- Delete the log file (`/var/log/dummy-service.log`).
- Reload the systemd daemon.

## Notes and Best Practices

- **Path Selection:** The current installation directory is `/usr/bin/dummy/`, which is unconventional. For production deployments, consider using `/usr/local/bin/` for custom scripts.
- **Permissions:** The service currently runs with root privileges to write to `/var/log/`. In a production environment, consider running under a dedicated user for enhanced security.
- **Journal Persistence:** By default, systemd journal logs may not persist across reboots. To retain logs, edit `/etc/systemd/journald.conf` and set `Storage=persistent`.
