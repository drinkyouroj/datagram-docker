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

# Remove any existing container with the same name
docker rm -f datagram 2>/dev/null || true

# Run the container in detached mode
echo "Starting Datagram container in the background..."
echo "Using license key: ${DATAGRAM_KEY:0:4}...${DATAGRAM_KEY: -4}"

docker run -d \
    --name datagram \
    --restart unless-stopped \
    --env DATAGRAM_KEY="$DATAGRAM_KEY" \
    datagram

echo "Container started in the background."
echo "To view logs:     sudo docker logs -f datagram"
echo "To stop:         sudo docker stop datagram"
echo "To remove:       sudo docker rm -f datagram"
