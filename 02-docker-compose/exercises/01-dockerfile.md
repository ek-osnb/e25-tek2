# Docker: Dockerfile

A [`Dockerfile`](https://docs.docker.com/reference/dockerfile/) is a file that contains all the commands to build a Docker image. It contains all information needed to create a Docker container, including the base image, environment variables, and any dependencies required to run the application.

A `Dockerfile` is a text document that contains a series of instructions and commands that are executed in order to build a Docker image. Each instruction in the `Dockerfile` creates a layer in the image, and the final image is a combination of all these layers.

Note that the `Dockerfile` is typically named "Dockerfile" (with a capital "D" and no file extension) and is located in the root of the build context directory.

## Basic Dockerfile commands

The following are some of the most commonly used commands in a `Dockerfile`:

- `FROM`: Specifies the base image to use for the Docker image.
- `RUN`: Executes a command in the shell and creates a new layer in the image.
- `COPY`: Copies files from the host machine to the image.
- `WORKDIR`: Sets the working directory for any `RUN`, `CMD`, and `ENTRYPOINT` instructions that follow it in the `Dockerfile`.
- `CMD`: Specifies the command to run when the container starts (can be overwritten)
- `ENTRYPOINT`: Similar to `CMD`, but sets the command that will always be run in the container.

## Dockerizing a Spring application

In this exercise, we will create a `Dockerfile` for a Spring Boot REST API application.

## Step 1: Create a Dockerfile

In an empty directory, create a new file named `Dockerfile` (with no file extension).

First we need to use a **base image**, we will use the [maven](https://hub.docker.com/layers/library/maven/3.9.11-eclipse-temurin-21/images/sha256-3e8012d0a4a48f366dc8cfade527db0c2491e5cf24484bc644801d87e5234ac3) base image:

```dockerfile
FROM maven:3.9.11-eclipse-temurin-21
```
Here `maven:3.9.11` specifies the maven version and `eclipse-temurin-21` specifies the JDK version.

## Step 2: Add application files

Next, we need to copy the application files into the Docker image. We will use the `COPY` command to do this:

```dockerfile
WORKDIR /app
COPY pom.xml .
COPY src ./src
```
We set the `WORKDIR` to `/app`, this means that all subsequent commands will be run from this directory. 

Then we first copy the `pom.xml` file into the `/app` directory, followed by the `src` directory.

The reason why we split it up, is because each command creates a new layer in the Docker image. Every layer is cached, so if we change the source code, Docker can reuse the cached layers for the `pom.xml` file and the Maven dependencies, speeding up the build process.

## Step 3: Building the application

Now we need to build the application using Maven. We will use the `RUN` command to do this:

```dockerfile
RUN mvn clean package -DskipTests
```
This will run the Maven build process and create a JAR file in the `target` directory.

## Step 4: Extracting the JAR file

Finally, we need to extract the JAR file from the `target` directory and set it as the entry point for the Docker container. We will use the `COPY` command to do this:

```dockerfile
RUN cp target/*.jar app.jar
```

## Step 5: Setting the entry point

Then we will set the `ENTRYPOINT` for the container:

```dockerfile
ENTRYPOINT ["java", "-jar", "app.jar"]
```

This tells Docker to run the `java -jar app.jar` command when the container starts.

## Step 6: Building the Docker image

Now that we have our `Dockerfile` ready, we can build the Docker image using the following command:

```bash
docker build -t spring-api .
```

This command will build the Docker image and tag it as `spring-api`.

## Step 7: Running the Docker container

Now that we have our Docker image built, we can run a container from it using the following command:

```bash
docker run -d -p 8080:8080 spring-api
```

This command will run a new container (in the background) from the `spring-api` image and map port 8080 on the host to port 8080 in the container.


## Full Dockerfile

```dockerfile
FROM maven:3.9.11-eclipse-temurin-21

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

RUN cp target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
```