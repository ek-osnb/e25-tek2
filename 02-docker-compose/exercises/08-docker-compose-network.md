# Docker Compose networking

## Goal:

Understand Docker Compose networking and how to define custom networks for our services.

## Step 1: Defining a custom network

If we dont specify a network, docker will automatically create a default network for our application.

However, we can define a custom network in the `docker-compose.yml` file.

```yaml
networks:
  spring-mysql:
    driver: bridge
```

Then, we can attach our services to this network:

```yaml
services:
  db:
    networks:
      - spring-mysql

  app:
    networks:
      - spring-mysql
```

## Step 2: Removing port exposure

Since the services are connected over a custom network, we can remove the database exposure to the host machine, as it is no longer needed. Update the `docker-compose.yml` file to remove the `ports` section from the `db` service:

```yaml
services:
  db:
    ports:
      - "3306"
    networks:
      - spring-mysql

  app:
    ports:
      - "127.0.0.1:8080:8080"
    networks:
      - spring-mysql
```

Even though the database is isolated inside the container, it is still accessible to the app container over the custom network.

## Step 3: Compose everything

Run `docker compose up -d` to start the services in detached mode.

## Step 4: Inspect the network

We can inspect the network, to show which containers are in the network.

First list the networks:

```bash
docker network ls
```

There should be a network named `docker-spring_spring-mysql`, try to inspect it, by running:

```bash
docker network inspect docker-spring_spring-mysql
```

Here you can see the containers that are connected to the network (under the "Containers" section).

## Step 5: Tear everything down

Tear it all down:

```bash
docker compose down -v
```

And do a (nuclear 💣) cleanup:

```bash
docker system prune -f
```