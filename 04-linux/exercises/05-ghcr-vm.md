# Guided Exercise: Using GitHub Container Registry (GHCR) on a VM

In this exercise, you will learn how to authenticate with GitHub Container Registry (GHCR) using a Personal Access Token (PAT), pull your own Docker image, and run it on your VM.

## Step 1: Create a Personal Access Token (PAT)

1. Go to [https://github.com/settings/tokens](https://github.com/settings/tokens) and click **Generate new token** use the **classic** option.
2. Give your token a name and select the following scopes:
	- `read:packages` (to pull images)
	- `write:packages` (if you want to push images)
	- `repo` (if your image is in a private repo)
3. Generate the token and **copy it somewhere safe** (you won't be able to see it again).

## Step 2: Authenticate Docker with GHCR

1. On your VM, log in to GHCR using your GitHub username and the PAT you just created:
	```bash
	echo <YOUR_PAT> | docker login ghcr.io -u <YOUR_GITHUB_USERNAME> --password-stdin
	```
	Replace `<YOUR_PAT>` and `<YOUR_GITHUB_USERNAME>` with your actual values.

## Step 3: Pull Your Image from GHCR

1. Find the name of your image on GHCR. It will look like:
	```
	ghcr.io/<your-github-username>/<image-name>:<tag>
	```
2. Pull your image:
	```bash
	docker pull ghcr.io/<your-github-username>/<image-name>:<tag>
	```

## Step 4: Running docker compose
1. Create a `docker-compose.yml` file to run your image. You should have a compose file from when you created your image, if not create one using `nano` or `vim`:
2. If you have environment variables, create a `.env` file in the same directory as your `docker-compose.yml` file and add your variables there.


## Step 5: Running the container
1. Start your container using Docker Compose:
    ```bash
    docker compose up -d
    ```
2. Verify that your container is running:
    ```bash
    docker ps -a
    ```