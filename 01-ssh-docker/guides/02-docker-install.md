# Docker Desktop installation guide

This guide will help you install Docker Desktop on your machine (**MacOS**, **Windows**, or **Linux**).

## Step 1: Download Docker Desktop
1. Go to the [Docker Desktop download page](https://www.docker.com/products/docker-desktop/).

2. Choose the version for your operating system (Windows, macOS, or Linux) and download the installer. For Apple M-chips, choose the version for Apple Silicon.

## Step 2: Install Docker Desktop

### Installation guide for MacOS:
1. Follow step 2 through 7 [here](https://docs.docker.com/desktop/install/mac-install/).

### Installation guide for Windows:

1. Install WSL 2 (Windows Subsystem for Linux) if you haven't already. You can follow the instructions [here](https://docs.docker.com/desktop/setup/install/windows-install/#wsl-verification-and-setup).

2. Follow step 2-6 [here](https://docs.docker.com/desktop/setup/install/windows-install/#install-docker-desktop-on-windows).


## Step 3: Verify Docker Installation

1. Open a terminal (Windows: GitBash, MacOS: Terminal).

2. Run the following command to check if Docker is installed correctly:

    ```bash
    docker --version
    ```

You should see the Docker version information displayed in the terminal.

## Step 4: Hello world with Docker

1. To verify that Docker is running correctly, you can run a simple "Hello World" container. Run the following command in your terminal:
    ```bash
    docker run hello-world
    ```

2. If Docker is installed correctly, you should see a message containing "Hello from Docker!"