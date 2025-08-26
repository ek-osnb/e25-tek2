# Dockerizing a Maven project

This guide will walk you through the steps to create a Docker image for a simple Maven project. The project will be built using Maven and then packaged into a Docker container, allowing you to run it anywhere Docker is available.

## Introduction to `Dockerfile`
A `Dockerfile` is a text document that contains all the commands to assemble an image.
It is used to automate the process of building Docker images. 

A `Dockerfile` consists of a series of instructions that define how to build a Docker image. Each instruction creates a layer in the image, and the final image is built by combining all these layers.

### Some common `Dockerfile` instructions include:

- `FROM`: Specifies the base image to use for the Docker image.
- `RUN`: Executes a command in the shell and creates a new layer in the image.
- `COPY`: Copies files from the host machine into the Docker image.
- `ENTRYPOINT`: Sets the command that will always run when the container starts.
- `CMD`: Specifies the command to run when the container starts, this can be overridden by the user when running the container.

## Step 0: Create a Maven project
Create a simple Maven project using IntelliJ, with only a Main class that prints `"Hello, World!"` to the console. The project structure should look like this:

```
my-maven-app/
├── pom.xml
└── src
    └── main
        └── java
            └── com.example.demo
                └── Main.java
```


## Step 1: Create a Dockerfile

Create a file named `Dockerfile` in the root of your Maven project directory. This file will contain the instructions to build your Docker image.

```dockerfile
# Use the official Maven image as the base image
FROM maven:3.9.9-eclipse-temurin-21
# maven - This is the official Maven image from Docker Hub.
# 3.9.9-eclipse-temurin-21 - this is the Maven version and 21 is the JDK version.

# Set the working directory
WORKDIR /app
# Copy the pom.xml
COPY pom.xml .

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "target/demo-1.0-SNAPSHOT.jar"]
```
#### Why do we split the `COPY` commands for `pom.xml` and `src`?

    This is done to leverage Docker's caching mechanism. By copying the `pom.xml` first, Docker can cache the dependencies. If only the source code changes, Docker will not need to re-download the dependencies, speeding up the build process.


## Step 2: Build the Docker image
Open a terminal in the root of your Maven project and run the following command to build the Docker image:

```bash
docker build -t my-maven-app .
```
This command will create a Docker image named `my-maven-app` based on the instructions in your `Dockerfile`.

To verify that the image was created successfully, you can run:

```bash
docker images
```
This will list all Docker images on your machine, and you should see `my-maven-app` in the list. Like this:

```plaintext
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
my-maven-app   latest    d8fea003614a   5 seconds ago   866MB
```

## Step 3: Run the Docker container
Now that you have built the Docker image, you can run it as a container. Use the following command:
```bash
docker run --rm my-maven-app
```
The `--rm` flag ensures that the container is removed after it stops running.

You should see the output from your Maven application in the terminal.

## Step 4: Making the image smaller: Multi-stage builds
To reduce the size of your Docker image, you can use a multi-stage build. This allows you to separate the build environment from the runtime environment, resulting in a smaller final image.

Update your `Dockerfile` to the following:

```dockerfile
# Use the official Maven image as the build stage
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Use a smaller base image for the runtime stage
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar ./app.jar

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

Build the Docker image again with the same command:

```bash
docker build -t my-maven-app .
```
This will create a smaller Docker image because it only contains the JRE and the built JAR file, without the Maven build tools.

See the size of the new image by running:

```bash
docker images
```
You should see that the size of the image (`my-maven-app`) is significantly smaller than before,
```bash
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
my-maven-app   latest    916a6f7028d2   3 seconds ago   283MB
```

### Run the Docker container again:

```bash
docker run --rm my-maven-app
```
You should see the same output from your Maven application, but now the Docker image is much smaller.
