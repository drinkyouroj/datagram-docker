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

2. Make the run script executable:
   ```bash
   chmod +x run.sh
   ```

3. Run the setup script (it will prompt for your license key):
   ```bash
   sudo ./run.sh
   ```
   
   Alternatively, you can set the license key as an environment variable:
   ```bash
   export DATAGRAM_KEY='your-license-key-here'
   sudo -E ./run.sh
   ```

## Managing the Container

- View logs:
  ```bash
  sudo docker logs -f datagram
  ```

- Stop the container:
  ```bash
  sudo docker stop datagram
  ```

- Start the container again:
  ```bash
  sudo docker start datagram
  ```

- Remove the container:
  ```bash
  sudo docker rm -f datagram
  ```

## How It Works

The setup is now simplified to run the Datagram CLI directly in the container:

1. The `Dockerfile` sets up an Ubuntu 22.04 container with the Datagram CLI installed.
2. The `entrypoint.sh` script runs the Datagram CLI with your provided license key.
3. The `run.sh` script handles building the image and running the container in detached mode.

The container is configured to automatically restart unless explicitly stopped.

## Troubleshooting

- If you get permission errors, make sure to run the commands with `sudo`
- Check the logs with `sudo docker logs datagram`
- To completely reset, remove the container and image, then rebuild:
  ```bash
  sudo docker rm -f datagram
  sudo docker rmi datagram
  ./run.sh
  ```

## License

MIT
