# Guided Exercise: Installing Docker on a VM

In this exercise, you will install Docker on your VM using the official Docker documentation. Then, you will automate the installation with a shell script.

## Step 1: Install Docker Manually

1. Use the [guide](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) to install Docker on your VM. Follow the instructions for Ubuntu.

2. Verify the installation:
    ```bash
    docker --version
    ```
    You should see output indicating that Docker is installed.

## Step 2: Automate with a Shell Script

1. Create a file called `docker-install.sh`:
	 ```bash
	 nano docker-install.sh
	 ```
2. Add the commands you used before to the script.

3. Make the script executable:
    ```bash
    chmod +x docker-install.sh
    ```
4. Delete your current Docker installation:
    ```bash
    sudo apt remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```
5. Run your script to reinstall Docker:
    ```bash
    ./docker-install.sh
    ```
6. Verify the installation again:
    ```bash
    docker --version
    ```
    You should see output indicating that Docker is installed.

**Tip:** Always check the latest instructions at https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository for updates.
