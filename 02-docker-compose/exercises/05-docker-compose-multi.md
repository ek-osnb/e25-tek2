# Docker: Multiple services in docker compose

So far we have only seen one service being run inside docker compose. In this exercise we will define two services, that can communicate with each other, and be started using a single command.

We will define a spring boot application and a MySQL database.

## Goal:

Have a MySQL and Spring Boot application running together using Docker Compose.


## Step 2: Adding docker compose support

We will reuse the `docker-compose.yml` file from the previous exercise and add a new service for the Spring Boot application.

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: secret
    ports:
      - "3307:3306"
    volumes:
      - db_data:/var/lib/mysql

  app:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/mydb
      SPRING_DATASOURCE_USERNAME: user
      SPRING_DATASOURCE_PASSWORD: secret
    ports:
      - "8080:8080"
    depends_on:
      - db

volumes:
  db_data:
```

To start the services, use the following command to start the containers in detached mode:

```bash
docker compose up -d
```

To check if everything is running, list the containers:

```bash
docker ps -a
```

You will notice that the Spring Boot application has exited with an error. To inspect the logs, use the following command:

```bash
docker logs <app_container_id>
```

Going through the logs, you will notice the following exception:

```bash
 org.hibernate.exception.JDBCConnectionException: unable to obtain isolated JDBC connection [Communications link failure
The last packet successfully received from the server was 0 milliseconds ago. The driver has not received any packets from the server.]
```

Spring Data JPA is trying to create a connection to the database, but it is failing because the database is not ready yet.

We can try to restart only the Spring Boot application service using the following command:

```bash
docker compose up -d app
```

Check the logs again:

```bash
docker logs backend
```

You should see something similar to this:

```bash
---------------
Initializing Database using CommandLineRunner
---------------
DB URL: jdbc:mysql://db:3306/mydb
Active Profiles: default
---------------
```

This means that the Spring Boot application has successfully established a connection to the MySQL database.

## Step 3: Adding a health check

First stop the two containers by running:
```bash
docker compose down -v
```

To make sure that the database is ready before the Spring Boot application starts, we can add a health check to the MySQL service in the `docker-compose.yml` file.

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: secret
    ports:
      - "3307:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 20s
      retries: 5

  app:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/mydb
      SPRING_DATASOURCE_USERNAME: user
      SPRING_DATASOURCE_PASSWORD: secret
      SPRING_JPA_HIBERNATE_DDL_AUTO: update
    ports:
      - "8080:8080"
    depends_on:
      db:
        condition: service_healthy

volumes:
  db_data:
```

The `healthcheck` section defined under the `db` service, defines how to check if the MySQL database is ready to accept connections. The command `test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]` is the command that will be run to check the health of the database. `timeout` is the maximum time to wait for the command to complete, and `retries` is the number of times to retry the command before considering the service unhealthy.

The `depends_on` section in the `app` service ensures that the Spring Boot application will only start after the MySQL database is considered healthy (we defined that under the `healthcheck` section).

## Step 4: Tear down

Run the following command to stop and remove the containers, and volumes defined in the `docker-compose.yml` file:

```bash
docker compose down -v
```
