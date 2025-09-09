# GitHub Actions: Testing a Dockerfile

## Goal
The goal of this exercise is to create a GitHub Action that tests a Dockerfile for a Spring Boot application.

## Step 1: Create a new workflow file
Inside the `.github/workflows` directory, create a new file named `docker-ci.yml`.

Open the `docker-ci.yml` file and add the following content:
```yaml
name: Docker CI
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
      - name: Build Docker image
        run: docker build -t app:test .

      - name: Run Docker container
        run: |
          # Run the container in detached mode
          docker run -d -p 8080:8080 --name test-container app:test
          
          # Wait for a few seconds to ensure the container is up and running
          sleep 20

          # Test the application endpoint
          curl -f http://localhost:8080/actuator/health || exit 1

          # Stop and remove the container
          docker stop test-container
          docker rm test-container
```

The pipe (`|`) in the `run` step allows you to write multi-line shell commands.

We could also use `docker compose up -d` to start the container, but for simplicity, we are using `docker run` here.

## Step 2: Commit and Push
For the action to take effect, you need to commit and push the changes to your repository.
You can do this using the following commands:
```bash
git add .
git commit -m "Add Docker CI GitHub Action"
git push
```

## Step 3: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "Docker CI" action. Click on
it to see the details.
4. Click on the job to see the logs. You should see the steps for checking out
the code, building the Docker image, running the container, and testing the
application endpoint.