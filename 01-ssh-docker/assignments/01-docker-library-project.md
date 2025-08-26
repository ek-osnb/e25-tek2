# Dockerize Spring Boot REST API

In this assignment we will add docker support to the Spring Boot REST API project: [Library project](https://github.com/ek-osnb/e25-prog2/blob/main/01-rest-api-and-spring-data-jpa/01-intro-to-rest-api-and-jpa/assignments/00-library-project-intro.md).


## Step 1: Create a Docker file

Create a file named `Dockerfile` in the root of your project directory with the following content:

```dockerfile
# Use the official Maven image as the base image
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

## Step 2: Build the Docker image

To build the Docker image, run the following command in the root of your project directory:

```bash
docker build -t lib-api .
```

## Step 3: Run the Docker container

To run the Docker container, use the following command:
```bash
docker run -d -p 8080:8080 --name lib-container lib-api
```

You should now be able to access the Spring Boot REST API at `http://localhost:8080/api/works`.

## Step 5: Cleanup

To stop the Docker container, use the following command:
```bash
docker stop lib-container
```

## Step 6: Remove the Docker container

To remove the Docker container, use the following command:
```bash
docker rm lib-container
```