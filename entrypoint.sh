#!/bin/bash
set -e

# Check if license key is provided
if [ -z "$DATAGRAM_KEY" ]; then
    echo "Error: DATAGRAM_KEY environment variable is not set." >&2
    echo "Please run the container with -e DATAGRAM_KEY='your-license-key'"
    exit 1
fi

# Run datagram with the provided key
exec datagram run -- -key "$DATAGRAM_KEY"
