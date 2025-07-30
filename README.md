# Datagram Docker Setup

This repository contains the necessary files to run the Datagram CLI inside a Docker container.

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

2. Make the script executable:
   ```bash
   chmod +x run.sh
   ```

3. Run the script:
   ```bash
   ./run.sh
   ```

The script will automatically handle your license key in the following order:
1. **Environment Variable**: Checks if `DATAGRAM_KEY` is already set
2. **File**: Looks for `~/.datagram_key` file in your home directory
3. **Prompt**: If neither exists, prompts you to enter your license key

## License Key Management

### Option 1: Environment Variable (Temporary)
```bash
export DATAGRAM_KEY=your_license_key_here
./run.sh
```

### Option 2: Save to File (Persistent)
```bash
echo "your_license_key_here" > ~/.datagram_key
./run.sh
```

### Option 3: Interactive Prompt
Simply run `./run.sh` and enter your license key when prompted.

## Managing the Container

After running the script, you can manage the container with standard Docker commands:

- View logs:
  ```bash
  docker logs -f datagram
  ```

- Stop the container:
  ```bash
  docker stop datagram
  ```

- Remove the container:
  ```bash
  docker rm -f datagram
  ```

- Restart the container:
  ```bash
  docker start datagram
  ```

## How It Works

1. The `run.sh` script handles license key retrieval from multiple sources
2. It stops any existing `datagram` container
3. Starts a new container with your license key passed as an environment variable
4. The container runs in the background with automatic restart enabled

The container is configured to automatically restart unless explicitly stopped.

## Troubleshooting

- Check the logs: `docker logs -f datagram`
- Verify your license key is correct
- Make sure Docker is running
- To completely reset:
  ```bash
  docker rm -f datagram
  ./run.sh
  ```

## License

MIT
