# Docker: Multi-stage Dockerfile

In the previous exercise, we created a `Dockerfile` for a Spring Boot application.

We will reuse the existing `Dockerfile` and modify it to use multi-stage builds. The goal of multi-stage builds is to reduce the size of the final Docker image by separating the build environment from the runtime environment.

# Goal:

The goal in this exercise, is to create a multi-stage Dockerfile for a Spring Boot application, to reduce the final image size.

## Step 1: Check image size

Before we start, let's check the size of the existing Docker image:

```bash
docker images spring-api
```

This command will show the size of the `spring-api` image, you will get an ouput like this:

```bash
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
spring-api   latest    35556a893585   2 minutes ago   1.23GB
```
Notice that the image size is **1.23GB**.

## Step 2: Multi-stage
We will split the build process into two stages (a build stage and a runtime stage), to reduce the final image size.

```dockerfile
# Build stage
FROM maven:3.9.11-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

The build stage is explained in the previous exercise. The Runtime stage uses a smaller base image (JRE Alpine). It copies the JAR file from the build stage, and rename it to `app.jar`.

Then we set the `ENTRYPOINT` for the container.

Only the final stage will be included in the final image (i.e. the runtime stage).

## Step 3: Build the image
Now that we have our multi-stage Dockerfile, we can build the Docker image.

```bash
docker build -t spring-multi .
```

Check the size of the newly created image:

```bash
docker images
```

You should get a similar output:
```bash
REPOSITORY     TAG       IMAGE ID       CREATED         SIZE
spring-multi   latest    be4d5436413c   3 seconds ago   391MB
spring-api     latest    35556a893585   5 minutes ago   1.23GB
```

Notice that the size of the `spring-multi` image is significantly smaller than the `spring-api` image. This is because the final image only contains the JRE and the application JAR file, while the previous image contained the entire build environment, including all dependencies and build tools.


## Step 4: Run the Docker container
You can now run the Docker container using the following command:

```bash
docker run -p 8081:8080 spring-multi
```

This command maps port 8080 of the container to port 8081 on your host machine. You can now access the Spring Boot application at `http://localhost:8081`.

## Step 5: Cleanup
After you are done, you can stop the container and remove the images to free up space:

```bash
docker stop <container_id>
docker rm <container_id>
docker rmi spring-multi spring-api
```

Replace `<container_id>` with the actual container ID or name. You can find the container ID by running `docker ps` to list all running containers.