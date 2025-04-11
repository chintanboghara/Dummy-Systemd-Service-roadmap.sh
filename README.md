# Dummy Systemd Service

This project provides a simple, long-running systemd service that logs to a file. It is designed to help users become familiar with creating, managing, and monitoring a systemd service. The service runs a script that writes a message to a log file every 10 seconds, simulating a background application. Through this project, you will learn how to:

- Create and configure a systemd service.
- Enable and disable the service to start on boot.
- Start, stop, and check the status of the service.
- Monitor logs using both `journalctl` and a log file.

## Requirements

- A Linux system with systemd installed.
- Basic knowledge of the command line and text editors.
- Root or sudo access to install and manage the service.

## Installation

Follow these steps to install and set up the Dummy Systemd Service:

1. **Create the script:**

   Create a file named `dummy.sh` with the following content:

   ```bash
   #!/bin/bash

   while true; do
     echo "Dummy service is running..."
     sleep 10
   done
   ```

2. **Make the script executable and move it:**

   Run the following commands to make the script executable and move it to a standard directory:

   ```bash
   chmod +x dummy.sh
   sudo mv dummy.sh /usr/local/bin/
   ```

3. **Create the service file:**

   Create a file named `dummy.service` in `/etc/systemd/system/` with the following content:

   ```ini
   [Unit]
   Description=Dummy Service

   [Service]
   ExecStart=/bin/bash -c "/usr/local/bin/dummy.sh | tee /var/log/dummy-service.log"
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

4. **Reload the systemd daemon:**

   Inform systemd of the new service file by running:

   ```bash
   sudo systemctl daemon-reload
   ```

5. **Enable and start the service:**

   Enable the service to start on boot and start it immediately:

   ```bash
   sudo systemctl enable dummy
   sudo systemctl start dummy
   ```

## Usage

Once installed, you can manage the Dummy Systemd Service using the following `systemctl` commands:

- **Start the service:**

  ```bash
  sudo systemctl start dummy
  ```

- **Stop the service:**

  ```bash
  sudo systemctl stop dummy
  ```

- **Enable the service (start on boot):**

  ```bash
  sudo systemctl enable dummy
  ```

- **Disable the service (don't start on boot):**

  ```bash
  sudo systemctl disable dummy
  ```

- **Check the status of the service:**

  ```bash
  sudo systemctl status dummy
  ```

- **View the logs in real-time:**

  ```bash
  sudo journalctl -u dummy -f
  ```

- **Check the log file directly:**

  ```bash
  tail -f /var/log/dummy-service.log
  ```

## Testing

To verify that the service is working as expected:

1. **Check the status:**

   ```bash
   sudo systemctl status dummy
   ```

   This should show the service as active and running.

2. **View the logs:**

   ```bash
   sudo journalctl -u dummy -f
   ```

   You should see "Dummy service is running..." printed every 10 seconds.

3. **Stop the service:**

   ```bash
   sudo systemctl stop dummy
   ```

   The service should stop, and the logs should no longer update.

4. **Start the service again:**

   ```bash
   sudo systemctl start dummy
   ```

5. **Verify logs are being written to the file:**

   ```bash
   tail -f /var/log/dummy-service.log
   ```

   This should also show the log messages being written every 10 seconds.

## Notes

- **Permissions:**
  - The service runs as root by default, which allows it to write to `/var/log/dummy-service.log`. In a production environment, consider running the service as a non-root user with appropriate permissions.

- **Log Persistence:**
  - By default, journal logs may not persist across reboots. To make journal logs persistent, you can configure `/etc/systemd/journald.conf` by setting `Storage=persistent`.

- **Alternatives:**
  - If you prefer the script to write directly to the log file without using `tee`, you can modify the script to redirect output (e.g., `echo "message" >> /var/log/dummy-service.log`). However, this would prevent `journalctl` from capturing the output unless you configure additional logging.

- **Restart Behavior:**
  - The service is configured to restart automatically if it exits unexpectedly (e.g., due to a crash). However, it will not restart if stopped intentionally using `systemctl stop`.

- **Troubleshooting:**
  - If the service fails to start, ensure that:
    - The script is executable (`chmod +x /usr/local/bin/dummy.sh`).
    - The service file is correctly placed in `/etc/systemd/system/`.
    - You have reloaded the systemd daemon after creating or modifying the service file (`sudo systemctl daemon-reload`).
