#!/bin/bash
set -e

# Function to prompt for license key
prompt_license_key() {
    echo "Please enter your Datagram license key (found at https://demo.datagram.network/wallet?tab=licenses)"
    echo "(You can also set the DATAGRAM_KEY environment variable to skip this prompt)"
    echo -n "> "
    read -r DATAGRAM_KEY
    
    if [ -z "$DATAGRAM_KEY" ]; then
        echo "Error: License key cannot be empty" >&2
        exit 1
    fi
    
    export DATAGRAM_KEY
}

# Check if license key is provided as an environment variable
if [ -z "$DATAGRAM_KEY" ]; then
    prompt_license_key
fi

# Build the Docker image
echo "Building Datagram Docker image..."
docker build -t datagram .

# Run the container
echo "Starting Datagram container..."
echo "Using license key: ${DATAGRAM_KEY:0:4}...${DATAGRAM_KEY: -4}"

docker run \
    --rm \
    -it \
    --name datagram \
    --env DATAGRAM_KEY="$DATAGRAM_KEY" \
    datagram
