# Using environment variables

## Goal:
Extract the environment variables into a separate file, to keep the `docker-compose.yml` file free of sensitive information.

## Step 1: Create a `.env` file

Create a new file named `.env` in the same directory as your `docker-compose.yml` file. This file will contain all the environment variables for your services.

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydb
MYSQL_USER=user
MYSQL_PASSWORD=secret
SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/mydb
SPRING_DATASOURCE_USERNAME=user
SPRING_DATASOURCE_PASSWORD=secret
```
Make sure to add the `.env` file to your `.gitignore` file to prevent it from being committed to version control, as it contains sensitive information.

## Step 2: Using environment variables in `docker-compose.yml`

Now that we have our environment variables defined in the `.env` file, we can reference them in our `docker-compose.yml` file.

```yaml
services:
  db:
    container_name: db
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "3307:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 20s
      retries: 5

  app:
    container_name: backend
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      SPRING_DATASOURCE_URL: ${SPRING_DATASOURCE_URL}
      SPRING_DATASOURCE_USERNAME: ${SPRING_DATASOURCE_USERNAME}
      SPRING_DATASOURCE_PASSWORD: ${SPRING_DATASOURCE_PASSWORD}
    ports:
      - "8080:8080"
    depends_on:
      db:
        condition: service_healthy

volumes:
  db_data:
```

## Step 3: Starting the services

Start the services using the following command:

```bash
docker compose up -d
```

This will create and start the containers in detached mode. You can check the status of the containers using the following command:

```bash
docker ps -a
```

## Step 4: Checking environment variables inside a container

To check that the environment variables are correctly set inside the running container, you can use the following command to enter the container:

```bash
docker exec -it backend sh
```
Once inside the container, you can use the `printenv` command to display all environment variables:

```bash
printenv
```
Verify that the environment variables are the same as those defined in the `.env` file.


---
Notice that we could also pass the `printenv` command directly to `docker exec` without entering the container:

```bash
docker exec backend printenv
```
---

## Step 5: Tear down

Stop and remove the containers and volumes using the following command:

```bash
docker compose down -v
```
