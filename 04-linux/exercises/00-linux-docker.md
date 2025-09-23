# Guided Exercise: Running a Linux Container with Docker Compose

In this exercise, you will learn how to quickly start a Linux container using Docker Compose. This is useful for experimenting with Linux commands in a safe, isolated environment.

## Step 1: Create a Project Folder

1. Make a new directory for your project and move into it:
	```bash
	mkdir linux-container-demo
	cd linux-container-demo
	```

## Step 2: Create a `docker-compose.yml` File

1. Create a file named `docker-compose.yml` with the following content:
	```yaml
	services:
	  linux:
		 image: ubuntu:latest
		 tty: true
	```
    The `tty: true` line keeps the container running so you can interact with it.

## Step 3: Start the Container

1. Run the following command to start your Linux container:
	```bash
	docker compose up -d
	```
	This will download the Ubuntu image (if needed) and start the container in the background.

## Step 4: Access the Container

1. Open a shell inside your running container:
	```bash
	docker compose exec linux bash
	```
	Now you are inside a real Ubuntu Linux environment!

## Step 5: Install Essential Tools
1. Update the package list and install some essential tools:
    ```bash
    apt update
    apt install -y vim nano wget tar gzip
    ```
2. You can now use commands like `vim`, `nano`, `wget`, `tar`, and `gzip` inside the container.

## Step 6: Using the tools
1. Create a test file using `nano` or `vim`:
    ```bash
    nano testfile.txt
    ```
    Add some text and save the file (`CTRL+X` then `Y` and `ENTER` for nano).
2. Download one of your GitHub repositories using `wget`:
    ```bash
    wget https://github.com/username/repo/archive/refs/heads/main.zip
    ```
3. Unzip the downloaded file (you might need to install `unzip` first):
    ```bash
    apt install unzip
    ````
    ```bash
    unzip main.zip
    ```
4. Try navigating into the unzipped directory and listing files using commands like `cd` and `ls`.

5. Download the bashcrawl game:
    ```bash
    wget https://gitlab.com/slackermedia/bashcrawl/-/archive/stable-2024.02.09/bashcrawl-stable-2024.02.09.tar.gz
    ```
    And extract it:
    ```bash
    tar xzf bashcrawl-stable-2024.02.09.tar.gz
    ```
    Rename it to `bashcrawl`:
    ```bash
    mv bashcrawl-stable-2024.02.09 bashcrawl
    ```
6. Navigate into the `bashcrawl/entrance` directory and start the game:
    ```bash
    cd bashcrawl/entrance
    ```
7. Try navigating through the game.

## Step 7: Clean Up

1. When you are done, you can stop and remove the container with:
	```bash
	docker compose down
	```

---

**Tip:** You can edit the `docker-compose.yml` file to try other Linux images (like `alpine`, etc.) or add more services.

**Note:** We could also have created a Dockerfile to customize the image, and giving us a ready-to-use environment with all the tools pre-installed including the bashcrawl game.