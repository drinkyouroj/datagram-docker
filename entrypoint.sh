#!/bin/bash

# Check if DATAGRAM_KEY is set
if [ -z "$DATAGRAM_KEY" ]; then
    echo "Error: DATAGRAM_KEY environment variable is not set." >&2
    exit 1
fi

# Run datagram with the provided key
exec datagram run -- -key "$DATAGRAM_KEY"
