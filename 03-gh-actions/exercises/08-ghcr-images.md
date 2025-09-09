# GitHub Container Registry (GHCR) Images

## Goal
The goal of this exercise is to pull the Docker image you pushed to the GitHub Container Registry (GHCR) in the previous exercise and run it locally.

## Step 1: Pull the Docker Image
To pull the Docker image from GHCR, use the following command. Replace `YOUR_GITHUB_USERNAME` and `YOUR_REPOSITORY_NAME` with your actual GitHub username and repository name.

```bash
docker pull ghcr.io/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME:latest
```

## Step 2: Create a new docker-compose.ghcr.yml file
In the root of your repository, create a new file named `docker-compose.ghcr.yml`.

Open the `docker-compose.ghcr.yml` file and add the following content:

```yaml
services:
  app:
    image: ghcr.io/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME:latest
    ports:
      - "8090:8080"
```

Make sure to replace `YOUR_GITHUB_USERNAME` and `YOUR_REPOSITORY_NAME` with your actual GitHub username and repository name.

## Step 3: Run the Docker Container
To run the Docker container in detached mode using the `docker-compose.ghcr.yml` file, use the following command:

```bash
docker compose -f docker-compose.ghcr.yml up -d
```

## Step 4: Verify the Application
To verify that the application is running correctly, you can use the following command to check the health endpoint:
```bash
curl http://localhost:8090/actuator/health
```
You should see a response indicating that the application is healthy.

## Step 5: Stop the Docker Container
To stop and remove the Docker container, use the following command:
```bash
docker compose -f docker-compose.ghcr.yml down
```

## Step 6: Clean Up
If you want to remove the pulled Docker image from your local machine, you can use the following command:
```bash
docker rmi ghcr.io/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY_NAME:latest
```
Make sure to replace `YOUR_GITHUB_USERNAME` and `YOUR_REPOSITORY_NAME` with your actual GitHub username and repository name.

