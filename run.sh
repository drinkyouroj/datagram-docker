#!/bin/bash
set -e

# Function to get license key from various sources
get_license_key() {
    # First check if DATAGRAM_KEY is already set in environment
    if [ -n "$DATAGRAM_KEY" ]; then
        echo "Using DATAGRAM_KEY from environment variable"
        return 0
    fi
    
    # Check for .datagram_key file in home directory
    local key_file="$HOME/.datagram_key"
    if [ -f "$key_file" ]; then
        echo "Reading DATAGRAM_KEY from $key_file"
        DATAGRAM_KEY=$(cat "$key_file" | tr -d '\n\r')
        if [ -n "$DATAGRAM_KEY" ]; then
            export DATAGRAM_KEY
            return 0
        fi
    fi
    
    # Prompt user for license key if not found
    echo "Please enter your Datagram license key (found at https://demo.datagram.network/wallet?tab=licenses)"
    echo -n "> "
    read -r DATAGRAM_KEY
    
    if [ -z "$DATAGRAM_KEY" ]; then
        echo "Error: License key cannot be empty" >&2
        exit 1
    fi
    
    # Export to current session
    export DATAGRAM_KEY
    echo "DATAGRAM_KEY exported to current session"
}

# Function to stop and remove existing container
stop_and_remove_container() {
    echo "Stopping and removing existing container..."
    docker rm -f datagram 2>/dev/null || true
}

# Function to run the container
run_container() {
    echo "Starting Datagram container..."
    echo "Using license key: ${DATAGRAM_KEY:0:4}...${DATAGRAM_KEY: -4}"

    docker run -d \
        --name datagram \
        --restart unless-stopped \
        --env DATAGRAM_KEY="$DATAGRAM_KEY" \
        datagram

    echo "Container started successfully!"
    echo "To view logs:     docker logs -f datagram"
    echo "To stop:          docker stop datagram"
    echo "To remove:        docker rm -f datagram"
}

# Main execution
echo "Starting Datagram..."

# Get the license key from environment, file, or user input
get_license_key

# Stop any existing container
stop_and_remove_container

# Run the new container
run_container
