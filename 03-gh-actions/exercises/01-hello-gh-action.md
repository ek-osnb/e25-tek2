# Hello GitHub Actions

## Goal
The goal of this exercise is to create a simple GitHub Action that prints "Hello, World!" to the console.

## Step 1: setup

Fork this repository to your own GitHub account: https://github.com/ek-osnb/spring-ghcr

Clone your forked repository to your local machine:
```bash
git clone git@github.com:YOUR_GITHUB_USERNAME/spring-ghcr.git
```

This repository contains a simple Spring Boot application. You will add a GitHub Action to this repository.

**Try running the application locally first to ensure everything is working:**
```bash
docker compose up -d
```

The app has two endpoints:
- `http://localhost:8090` - returns "Hello, World!"
- `http://localhost:8090/actuator/health` - returns the health status of the application

**Take a moment to explore the project structure and understand how it works - especially the resources folder.**


## Step 2: Create the Action
1. In the root of your repository, create a new directory called `.github/workflows`.
2. Inside the `.github/workflows` directory, create a new file named `hello-world.yml`.
3. Open the `hello-world.yml` file and add the following content:
```yaml
name: Hello World Action
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v5
     
     - name: Run script
        run: echo "Hello, World!"
```

The first step checks out the repository code, which clones the repository to the runner (the virtual machine where the action runs - in this case a GitHub-hosted `ubuntu` runner).

This YAML file defines a GitHub Action that triggers on every push to the repository. It checks out the code and then runs a script that prints "Hello, World!" to the console.

## Step 3: Commit and Push
For the action to take effect, you need to commit and push the changes to your repository. You can do this using the following commands:
```bash
git add .
git commit -m "Add Hello World GitHub Action"
git push
```

## Step 4: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "Hello World Action". Click on it to see the details.
4. Click on the job to see the logs. You should see "Hello, World!" printed in the logs.