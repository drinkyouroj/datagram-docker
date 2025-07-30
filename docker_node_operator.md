# Complete Guide: Installing Docker and Running Datagram on Mac

## Step 1: Install Docker on Mac

### Option A: Docker Desktop (Recommended)

1. **Download Docker Desktop**
   - Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
   - Click "Download for Mac"
   - Choose the correct version for your Mac:
     - **Apple Silicon (M1/M2/M3)**: Download "Mac with Apple chip"
     - **Intel Mac**: Download "Mac with Intel chip"

2. **Install Docker Desktop**
   - Open the downloaded `.dmg` file
   - Drag the Docker icon to your Applications folder
   - Launch Docker from Applications
   - Follow the setup wizard and agree to the terms

3. **Verify Installation**
   - Docker Desktop should show a whale icon in your menu bar
   - Open Terminal and run:
     ```bash
     docker --version
     ```
   - You should see something like: `Docker version 24.0.x`

### Option B: Homebrew Installation

If you prefer using Homebrew:

1. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Docker**:
   ```bash
   brew install --cask docker
   ```

3. **Launch Docker Desktop** from Applications and complete setup

## Step 2: Get Your Datagram License Key

1. **Sign up for Datagram** (if you haven't already):
   - Go to [https://dashboard.datagram.network](https://dashboard.datagram.network?ref=535715481)
   - Create an account

2. **Get your license key**:
   - Visit [https://demo.datagram.network/wallet?tab=licenses](https://demo.datagram.network/wallet?tab=licenses)
   - Copy your license key (it will look like a long string of characters)

## Step 3: Pull and Run the Datagram Container

1. **Open Terminal** (Applications → Utilities → Terminal)

2. **Pull the Datagram image**:
   ```bash
   docker pull 0justin/datagram
   ```
   
   This downloads the latest Datagram container image from Docker Hub.

3. **Run the container** (replace `your_license_key_here` with your actual license key):
   ```bash
   docker run -d \
     --name datagram \
     --restart unless-stopped \
     -e DATAGRAM_KEY=your_license_key_here \
     0justin/datagram
   ```

   **Command breakdown**:
   - `-d`: Run in background (detached mode)
   - `--name datagram`: Give the container a friendly name
   - `--restart unless-stopped`: Automatically restart if it crashes
   - `-e DATAGRAM_KEY=your_license_key_here`: Pass your license key as an environment variable
   - `0justin/datagram`: The Docker image to run

## Step 4: Verify Everything is Working

1. **Check if the container is running**:
   ```bash
   docker ps
   ```
   You should see your `datagram` container listed.

2. **View the logs**:
   ```bash
   docker logs -f datagram
   ```
   Press `Ctrl+C` to stop viewing logs.

## Managing Your Datagram Container

### Common Commands

- **View logs**:
  ```bash
  docker logs -f datagram
  ```

- **Stop the container**:
  ```bash
  docker stop datagram
  ```

- **Start the container** (if stopped):
  ```bash
  docker start datagram
  ```

- **Restart the container**:
  ```bash
  docker restart datagram
  ```

- **Remove the container** (stops and deletes it):
  ```bash
  docker rm -f datagram
  ```

### Updating to a New Version

When a new version is released:

1. **Stop and remove the old container**:
   ```bash
   docker rm -f datagram
   ```

2. **Pull the latest image**:
   ```bash
   docker pull 0justin/datagram
   ```

3. **Run the new container** (same command as Step 3):
   ```bash
   docker run -d \
     --name datagram \
     --restart unless-stopped \
     -e DATAGRAM_KEY=your_license_key_here \
     0justin/datagram
   ```

## Troubleshooting

### Common Issues

1. **"Docker command not found"**
   - Make sure Docker Desktop is running (whale icon in menu bar)
   - Restart Terminal after installing Docker

2. **"Permission denied"**
   - Make sure Docker Desktop is running
   - You shouldn't need `sudo` with Docker Desktop

3. **Container keeps restarting**
   - Check logs: `docker logs datagram`
   - Verify your license key is correct
   - Make sure your license key doesn't have extra spaces or characters

4. **"Port already in use"**
   - Stop any existing containers: `docker rm -f datagram`
   - Then run the container again

### Getting Help

- **Check container status**: `docker ps -a`
- **View detailed logs**: `docker logs datagram`
- **Check Docker Desktop**: Look for error messages in the Docker Desktop app

---

That's it! Your Datagram node should now be running in the background on your Mac. The container will automatically restart if your computer reboots, so you don't need to manually start it again.
