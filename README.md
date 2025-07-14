# Datagram Docker Setup

This repository contains the necessary files to run the Datagram CLI inside an Ubuntu 22.04 Docker container.

## Prerequisites

- Docker installed on your system
- A Datagram account (sign up at [Datagram](https://dashboard.datagram.network?ref=535715481))
- A valid Datagram license key (get it from [Datagram Wallet](https://demo.datagram.network/wallet?tab=licenses))
![Datagram Network Dashboard Licenses tab, with an arrow pointing to where to click to copy your license key](https://azure-adequate-krill-31.mypinata.cloud/ipfs/bafkreic66kkj4pqt7orgijy2rx5676sk4gyfrmhpxtl4wgbewytd3delh4)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/drinkyouroj/datagram-docker.git
   cd datagram-docker
   ```

2. Make the management script executable:
   ```bash
   chmod +x datagram.sh
   ```

3. Run the setup script (it will prompt for your license key):
   ```bash
   sudo ./datagram.sh
   ```
   
   Alternatively, you can set the license key as an environment variable:
   ```bash
   export DATAGRAM_KEY='your-license-key-here'
   sudo -E ./datagram.sh
   ```

   > **Note:** The script requires sudo privileges to interact with Docker. It will automatically check for sudo privileges and prompt you to run with sudo if needed.

## Managing the Container

The `datagram.sh` script provides a unified interface for managing the Datagram container:

- Check container status:
  ```bash
  sudo ./datagram.sh --status
  ```

- View logs:
  ```bash
  sudo ./datagram.sh --logs
  ```

- Update to the latest version (stops, removes, and rebuilds the container):
  ```bash
  sudo ./datagram.sh --update
  ```
  This is useful after new versions of the Datagram node software are released.

- Uninstall (stop and remove the container):
  ```bash
  sudo ./datagram.sh --uninstall
  ```

- Show help:
  ```bash
  sudo ./datagram.sh --help
  ```

> **Important:** All commands require sudo privileges as they interact with Docker. The script will automatically check for sudo privileges and exit with an error if not run with sudo.

### Manual Docker Commands (Alternative)

- Start the container:
  ```bash
  sudo docker start datagram
  ```

- Stop the container:
  ```bash
  sudo docker stop datagram
  ```

## Updating

To update to the latest version:

1. Pull the latest changes from the repository:
   ```bash
   git pull origin main
   ```

2. Run the update command:
   ```bash
   sudo ./datagram.sh --update
   ```

   This will:
   - Stop the running container
   - Remove the existing container
   - Rebuild the Docker image with the latest changes
   - Start a new container with your existing configuration

## How It Works

The setup is now simplified to run the Datagram CLI directly in the container:

1. The `Dockerfile` sets up an Ubuntu 22.04 container with the Datagram CLI installed.
2. The `entrypoint.sh` script runs the Datagram CLI with your provided license key.
3. The `datagram.sh` script provides a unified interface for managing the container:
   - Setting up and running the container
   - Checking container status with visual indicators (✅)
   - Viewing container logs
   - Uninstalling (stopping and removing) the container
   - Updating to the latest version

The container is configured to automatically restart unless explicitly stopped.

## Troubleshooting

- The script requires sudo privileges to interact with Docker. If you see permission errors, make sure to run all commands with `sudo`
- Check the logs with `sudo ./datagram.sh --logs`
- Check the container status with `sudo ./datagram.sh --status`
- To completely reset, uninstall and then run again:
  ```bash
  sudo ./datagram.sh --uninstall
  sudo docker rmi datagram
  sudo ./datagram.sh
  ```

## License

MIT
