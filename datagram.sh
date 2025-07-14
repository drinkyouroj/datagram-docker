#!/bin/bash
# Datagram Docker Management Script - Self-bootstrapping version
# Install with: wget -qO- https://raw.githubusercontent.com/drinkyouroj/datagram-docker/main/datagram.sh | sudo bash

set -e

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# GitHub repository information
REPO_URL="https://raw.githubusercontent.com/drinkyouroj/datagram-docker/main"

# Detect if script is being run via pipe (wget/curl)
if [ -t 0 ]; then
    # Terminal is interactive
    PIPED_EXECUTION=false
else
    # Being piped from wget/curl
    PIPED_EXECUTION=true
fi

# Installation directory
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ "$PIPED_EXECUTION" = true ] || [[ "$SCRIPT_PATH" == *wget* ]] || [[ "$SCRIPT_PATH" == *curl* ]] || [[ -z "$SCRIPT_PATH" ]]; then
    # Script is being piped from wget/curl
    INSTALL_DIR="${PWD}/datagram-docker"
    BOOTSTRAP_MODE=true
else
    # Script is being run from a file
    INSTALL_DIR="$(dirname "$(realpath "$0")")"
    BOOTSTRAP_MODE=false
fi

# Check if script is run with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Error: This script requires sudo privileges to interact with Docker${NC}"
        echo "Please run with sudo: sudo $0 $*"
        exit 1
    fi
}

# Function to create Dockerfile
create_dockerfile() {
    cat > "${INSTALL_DIR}/Dockerfile" << 'EOF'
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/Datagram-Group/datagram-cli-release/releases/latest/download/datagram-cli-x86_64-linux \
    && chmod +x datagram-cli-x86_64-linux \
    && mv datagram-cli-x86_64-linux /usr/local/bin/datagram

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["datagram", "run"]
EOF
    echo -e "${YELLOW}Created Dockerfile${NC}"
}

# Function to create entrypoint.sh
create_entrypoint() {
    cat > "${INSTALL_DIR}/entrypoint.sh" << 'EOF'
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
EOF
    chmod +x "${INSTALL_DIR}/entrypoint.sh"
    echo -e "${YELLOW}Created entrypoint.sh${NC}"
}

# Function to bootstrap the installation
bootstrap_installation() {
    echo -e "${YELLOW}🚀 Starting Datagram Docker bootstrap installation...${NC}"
    
    # Create installation directory
    echo -e "📁 Creating installation directory at ${INSTALL_DIR}..."
    mkdir -p "${INSTALL_DIR}"
    cd "${INSTALL_DIR}"
    
    # Download the main script
    echo -e "📥 Downloading Datagram Docker management script..."
    wget -q "${REPO_URL}/datagram.sh" -O datagram.sh
    chmod +x datagram.sh
    
    # Download other necessary files
    echo -e "📦 Downloading additional resources..."
    wget -q "${REPO_URL}/Dockerfile" -O Dockerfile || create_dockerfile
    wget -q "${REPO_URL}/entrypoint.sh" -O entrypoint.sh || create_entrypoint
    chmod +x entrypoint.sh
    
    echo -e "\n${GREEN}✅ Installation complete!${NC}"
    echo -e "${YELLOW}To run Datagram, use:${NC}"
    echo -e "cd ${INSTALL_DIR}"
    echo -e "sudo ./datagram.sh"
    
    # Exit after bootstrap if piped execution
    if [ "$PIPED_EXECUTION" = true ]; then
        echo -e "\n${YELLOW}Installation completed via piped execution.${NC}"
        echo -e "Please run the script manually to continue with setup."
        exit 0
    fi
}

# Function to ensure all required files exist
ensure_files_exist() {
    # Create Dockerfile if it doesn't exist
    if [ ! -f "${INSTALL_DIR}/Dockerfile" ]; then
        create_dockerfile
    fi

    # Create entrypoint.sh if it doesn't exist
    if [ ! -f "${INSTALL_DIR}/entrypoint.sh" ]; then
        create_entrypoint
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
    docker rm -f datagram 2>/dev/null || true
}

# Function to build and run the container
build_and_run() {
    # Ensure we're in the right directory with the Dockerfile
    cd "${INSTALL_DIR}"
    
    echo "Building Datagram Docker image..."
    docker build -t datagram .

    echo -e "${YELLOW}Starting Datagram container in the background...${NC}"
    echo "Using license key: ${DATAGRAM_KEY:0:4}...${DATAGRAM_KEY: -4}"

    docker run -d \
        --name datagram \
        --restart unless-stopped \
        --env DATAGRAM_KEY="$DATAGRAM_KEY" \
        datagram

    echo -e "${GREEN}Container started in the background.${NC}"
    echo ""
    echo "Management commands:"
    echo "  sudo ./datagram.sh --status    Check container status"
    echo "  sudo ./datagram.sh --logs      View container logs"
    echo "  sudo ./datagram.sh --uninstall Stop and remove container"
}

# Function to check if container is running
check_status() {
    if docker ps -q --filter "name=datagram" | grep -q .; then
        echo -e "${GREEN}✅ Datagram container is running${NC}"
        docker ps --filter "name=datagram" --format "ID: {{.ID}}\nName: {{.Names}}\nStatus: {{.Status}}\nCreated: {{.CreatedAt}}"
    else
        if docker ps -a -q --filter "name=datagram" | grep -q .; then
            echo -e "${RED}❌ Datagram container exists but is not running${NC}"
            docker ps -a --filter "name=datagram" --format "ID: {{.ID}}\nName: {{.Names}}\nStatus: {{.Status}}\nCreated: {{.CreatedAt}}"
        else
            echo -e "${RED}❌ Datagram container does not exist${NC}"
        fi
    fi
}

# Function to show container logs
show_logs() {
    if docker ps -a -q --filter "name=datagram" | grep -q .; then
        echo -e "${YELLOW}Showing logs for Datagram container:${NC}"
        docker logs -f datagram
    else
        echo -e "${RED}❌ Datagram container does not exist${NC}"
    fi
}

# Function to uninstall container
uninstall() {
    if docker ps -a -q --filter "name=datagram" | grep -q .; then
        echo -e "${YELLOW}Stopping and removing Datagram container...${NC}"
        docker rm -f datagram
        echo -e "${GREEN}Datagram container has been removed${NC}"
    else
        echo -e "${RED}❌ Datagram container does not exist${NC}"
    fi
}

# Check for sudo privileges before proceeding
check_sudo

# Ensure all required files exist if not in bootstrap mode
if [ "$BOOTSTRAP_MODE" = true ]; then
    bootstrap_installation
    exit 0
else
    ensure_files_exist
fi

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