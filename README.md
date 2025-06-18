# Datagram Docker Setup

This repository contains the necessary files to run the Datagram CLI inside an Ubuntu 22.04 Docker container, following the official Datagram documentation.

## Prerequisites

- Docker installed on your system
- A valid Datagram license key

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/datagram-docker.git
   cd datagram-docker
   ```

2. Make the run script executable:
   ```bash
   chmod +x run.sh
   ```

3. Run the setup script (it will prompt for your license key):
   ```bash
   ./run.sh
   ```
   
   Alternatively, you can set the license key as an environment variable:
   ```bash
   export DATAGRAM_KEY='your-license-key-here'
   ./run.sh
   ```

## How It Works

- The `Dockerfile` sets up an Ubuntu 22.04 container with the Datagram CLI installed.
- The `entrypoint.sh` script runs the Datagram CLI with your provided license key.
- The `run.sh` script handles building the Docker image and running the container.

## Stopping the Container

To stop the container, simply press `Ctrl+C` in the terminal where it's running.

## Environment Variables

- `DATAGRAM_KEY`: (Required) Your Datagram license key. Will be prompted if not provided.

## License

MIT
