# Docker networking

When running Docker containers, they run inside a lightweight, isolated environment. By default, each container has its own network namespace with its own IP address, routes, and network interfaces. To allow containers to communicate with each other or with the outside world, Docker provides several [networking modes](https://docs.docker.com/engine/network/).

Networking in Docker is based on the concept of virtual networks. When you create a Docker container, it is automatically connected to a default bridge network. You can also create custom networks and specify how containers should communicate with each other.

<!-- To create a custom network, you can use the `docker network create` command. For example, to create a network named `my_network`, you would run:

```bash
docker network create my_network
```

Once the network is created, you can connect containers to it using the `--network` flag when running a container:

```bash
docker run -d --name my_container --network my_network my_image
```

This allows containers on the same network to communicate with each other using their container names as hostnames. -->

# Goal:
The goal of this exercise is to create a Docker network for a Spring Boot application and a MySQL database, allowing them to communicate with each other, without exposing the database to the outside world.

## Step 1: Creating a network

To create a network in Docker, you can use the `docker network create` command. To create a network named `my_network`, you would run:

```bash
docker network create my-network
```

You can see the networks by running:

```bash
docker network ls
```

## Step 2: Running a MySQL container

When running a MySQL container, you can connect it to the network you created in Step 1. For example:

```bash
docker run -d --name my_mysql --network my-network -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=mydb -e MYSQL_USER=user -e MYSQL_PASSWORD=secret mysql:8.0
```

The `-e` flags are used to set environment variables inside the container. In this case, we are setting the root password, database name, user, and user password for the MySQL database.

Notice that we didn't specify a port mapping for the MySQL container. This is because the container is connected to the `my-network` network, and other containers on the same network can communicate with it using its container name (`my_mysql`) as the hostname.

## Step 3: Running a web application container

Use the spring application from the previous exercise, and build the image:

```bash
docker build -t spring-api .
```

We will now run the container using the same network, `my-network`:

```bash
docker run -d -p 8080:8080 --name my_web_app --network my-network spring-api
```

This command runs the Spring API container and maps port 8080 on the host to port 8080 in the container. But the issue is, that we are still using the in memory H2 database.

## Step 4: Checking the logs

To check the logs of the running container, you can use the `docker logs` command:

```bash
docker logs my_web_app
```

You will notice that the DB-URL is `jdbc:h2:mem:testdb`. How do we change this to use the MySQL database instead?


## Step 5: Setting environment variables for MySQL database

To connect the Spring application to the MySQL database, we need to set the appropriate environment variables when running the container. The Spring application expects the following environment variables to be set for database connection:

- `SPRING_DATASOURCE_URL`: The JDBC URL for the MySQL database
- `SPRING_DATASOURCE_USERNAME`: The username for the MySQL database
- `SPRING_DATASOURCE_PASSWORD`: The password for the MySQL database

Even though we already have the environment variables, set in the `application.properties` file, we can override them by setting new values when running the container. To do this, use the following command

```bash
docker run -d -p 8080:8080 --network my-network -e SPRING_DATASOURCE_URL=jdbc:mysql://my_mysql:3306/mydb -e SPRING_DATASOURCE_USERNAME=user -e SPRING_DATASOURCE_PASSWORD=secret -e spring-api
```

Now the application will run and connect to the MySQL database using the specified environment variables.

## Step 6: Verifying the connection

To verify that the Spring application is successfully connected to the MySQL database, you can check the logs of the Spring container. Use the following command to view the logs:

```bash
docker logs <container_id_or_name>
```

Look for any messages indicating a successful connection to the database. You can also try accessing the API endpoints (via `curl`) exposed by the Spring application to ensure everything is working as expected.

## Step 7: Cleaning up

Once you are done with the exercise, you stop and remove all containers and the network you created. Use the following commands:

```bash
docker stop <container_id_or_name>
docker rm <container_id_or_name>
docker rmi <image_id_or_name>
docker network rm my-network
```