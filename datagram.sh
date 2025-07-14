#!/bin/bash
# Make script executable with: chmod +x datagram.sh
set -e

# Datagram Docker Management Script
# This script provides a unified interface for managing the Datagram Docker container

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if script is run with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script requires sudo privileges to interact with Docker${NC}"
        echo "Please run with sudo: sudo $0 $*"
        exit 1
    fi
}

# Function to display usage instructions
show_usage() {
    echo -e "${YELLOW}Datagram Docker Management Script${NC}"
    echo ""
    echo "Usage: sudo $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  (no option)    Setup and run Datagram (prompts for license key if not set)"
    echo "  --status       Check if Datagram container is running"
    echo "  --logs         Show Datagram container logs"
    echo "  --uninstall    Stop and remove Datagram container"
    echo "  --update       Update to the latest version (stops, removes, and rebuilds)"
    echo "  --help         Show this help message"
    echo ""
    echo "Note: This script requires sudo privileges to interact with Docker"
}

# Function to prompt for license key
prompt_license_key() {
    echo -e "${YELLOW}Please enter your Datagram license key${NC}"
    echo "(Found at https://demo.datagram.network/wallet?tab=licenses)"
    echo "(You can also set the DATAGRAM_KEY environment variable to skip this prompt)"
    echo -n "> "
    read -r DATAGRAM_KEY
    
    if [ -z "$DATAGRAM_KEY" ]; then
        echo -e "${RED}Error: License key cannot be empty${NC}" >&2
        exit 1
    fi
    
    export DATAGRAM_KEY
}

# Function to stop and remove container
stop_and_remove_container() {
    echo "Stopping and removing existing container..."
    sudo docker rm -f datagram 2>/dev/null || true
}

# Function to build and run the container
build_and_run() {
    echo "Building Datagram Docker image..."
    sudo docker build -t datagram .

    echo -e "${YELLOW}Starting Datagram container in the background...${NC}"
    echo "Using license key: ${DATAGRAM_KEY:0:4}...${DATAGRAM_KEY: -4}"

    sudo docker run -d \
        --name datagram \
        --restart unless-stopped \
        --env DATAGRAM_KEY="$DATAGRAM_KEY" \
        datagram

    echo -e "${GREEN}Container started in the background.${NC}"
    echo ""
    echo "Management commands:"
    echo "  sudo $0 --status    Check container status"
    echo "  sudo $0 --logs      View container logs"
    echo "  sudo $0 --uninstall Stop and remove container"
}

# Function to check if container is running
check_status() {
    if sudo docker ps -q --filter "name=datagram" | grep -q .; then
        echo -e "${GREEN}✅ Datagram container is running${NC}"
        sudo docker ps --filter "name=datagram" --format "ID: {{.ID}}\nName: {{.Names}}\nStatus: {{.Status}}\nCreated: {{.CreatedAt}}"
    else
        if sudo docker ps -a -q --filter "name=datagram" | grep -q .; then
            echo -e "${RED}❌ Datagram container exists but is not running${NC}"
            sudo docker ps -a --filter "name=datagram" --format "ID: {{.ID}}\nName: {{.Names}}\nStatus: {{.Status}}\nCreated: {{.CreatedAt}}"
        else
            echo -e "${RED}❌ Datagram container does not exist${NC}"
        fi
    fi
}

# Function to show container logs
show_logs() {
    if sudo docker ps -a -q --filter "name=datagram" | grep -q .; then
        echo -e "${YELLOW}Showing logs for Datagram container:${NC}"
        sudo docker logs -f datagram
    else
        echo -e "${RED}❌ Datagram container does not exist${NC}"
    fi
}

# Function to uninstall container
uninstall() {
    if sudo docker ps -a -q --filter "name=datagram" | grep -q .; then
        echo -e "${YELLOW}Stopping and removing Datagram container...${NC}"
        sudo docker rm -f datagram
        echo -e "${GREEN}Datagram container has been removed${NC}"
    else
        echo -e "${RED}❌ Datagram container does not exist${NC}"
    fi
}

# Check for sudo privileges before proceeding
check_sudo

# Main script logic
case "$1" in
    --status)
        check_status
        ;;
    --logs)
        show_logs
        ;;
    --uninstall)
        uninstall
        ;;
    --update)
        # Check if license key is provided as an environment variable
        if [ -z "$DATAGRAM_KEY" ]; then
            prompt_license_key
        fi
        
        stop_and_remove_container
        build_and_run
        ;;
    --help)
        show_usage
        ;;
    "")
        # Default behavior - setup and run
        # Check if license key is provided as an environment variable
        if [ -z "$DATAGRAM_KEY" ]; then
            prompt_license_key
        fi
        
        stop_and_remove_container
        build_and_run
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        show_usage
        exit 1
        ;;
esac