# Exercise: Create a Docker container for Bashcrawl

In this exercise, you will create a Docker container for the Bashcrawl game. Bashcrawl is a text-based adventure game that runs in the terminal. You will learn how to write a `Dockerfile`, build a Docker image, and run a Docker container.

When running Bashcrawl, you will be able to navigate through a virtual world, solve puzzles, and interact with the environment using commands in the terminal.

## Step 1: Create a `Dockerfile`

1. Create a new directory `bashcrawl`, and inside create a file named `Dockerfile` (no file extension).

2. Open the `Dockerfile` in a text editor.

## Step 2: Write the `Dockerfile` Instructions

Add the following instructions to your `Dockerfile`:

```dockerfile
# Use the official base image
FROM alpine:latest

# Install neccesary alpine (linux) packages
RUN apk add --no-cache curl bash tar wget grep

# Get the bashcrawl source code
RUN wget https://gitlab.com/slackermedia/bashcrawl/-/archive/stable-2024.02.09/bashcrawl-stable-2024.02.09.tar.gz && tar xzf bashcrawl-stable-2024.02.09.tar.gz && mv bashcrawl-stable-2024.02.09 bashcrawl

# Set the working directory (where the commands will be executed)
WORKDIR /bashcrawl/entrance

# Set the entrypoint to run the bashcrawl script
ENTRYPOINT ["/bin/bash"]
```

## Step 3: Build the Docker Image

To build the Docker image, run the following command in the directory containing your `Dockerfile`:

```bash
docker build -t bashcrawl:latest .
```
- The `.` at the end specifies the build context, which is the current directory.
- The `-t` flag (same as `--tag`) tags the image with a name.

This command will create a Docker image named `bashcrawl` based on the instructions in your `Dockerfile`.


## Step 4: List Docker Images

To list all Docker images on your system, run the following command:

```bash
docker images
```

This command will display a list of all Docker images, including their repository names, tags, and image IDs.
You should see the `bashcrawl` image in the list, like this:

```plaintext
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
bashcrawl    latest    d8fea003614a   5 seconds ago   866MB
```

## Step 5: Run the Docker Container

Now that we have a Docker image, we can run it as a container. Use the following command:

```bash
docker run -it bashcrawl:latest
```
- The `-it` flags are used to run the container in interactive mode with a terminal attached. (`-i` for interactive and `-t` for terminal).
- If we omit `:latest`, Docker will use the `latest` tag by default.

This command will start a new container from the `bashcrawl` image and open an interactive terminal session inside the container.
