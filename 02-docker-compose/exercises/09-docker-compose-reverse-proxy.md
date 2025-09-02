# Docker compose: Adding a reverse proxy (optional exercise - draft)

## Goal:

Adding a single point of entry to our application using a reverse proxy (nginx).
This will allow us to route requests to different services based on the request URL, and make the services private as they do not need to expose a port.

## Step 1: Create a new docker-compose file

Create a new file called `docker-compose.prod.yml` in the same directory as your `docker-compose.yml` file.

In the `docker-compose.prod.yml` file, copy over the configuration from `docker-compose.yml`.

This file can contain different environment variables or settings for a production setup (although for this exercise, we will keep it simple).


## Step 2: Configuring nginx

Create a new file called `nginx.conf` in the same directory as your `docker-compose.yml` file. This file will contain the configuration for the reverse proxy.

```nginx
events {}

http {
  server {
    listen 80;

    location / {
      proxy_pass http://app:8080;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
}
```
This requires a little explanation:
- The `server` block defines a server that listens on port 80 (the default HTTP port).
- The `location /` block defines how to handle requests to the root URL i.e. `/`.
- The `proxy_pass` directive is used to specify the upstream server to which the request should be forwarded, in this case `http://app:8080`.
- The `proxy_set_header` directives are used to pass the original request headers to the `app` service. This is important for preserving information about the original request, such as the host and client IP address.

## Step 3: Updating the compose file

In `docker-compose.prod.yml` file, add the nginx service:

```yaml
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

We will also update the network
```yaml
networks:
  spring-mysql:
    driver: bridge
  nginx-spring:
    driver: bridge
```

And update the services to use the new network
```yaml
services:
  nginx:
    networks:
      - nginx-spring
  app:
    expose:
      - "8080"
    networks:
      - nginx-spring
      - spring-mysql
  db:
    expose:
      - "3306"
    networks:
      - spring-mysql
```

The idea here is, that we are using the reverse proxy to route requests to the appropriate service based on the request URL. This allows us to keep the services private and not expose their ports directly to the outside world. Instead, all requests go through the nginx reverse proxy, which then forwards them to the correct service (in this example only one service).

By splitting the networks, we can ensure that the database is not accessible from the nginx service, adding an extra layer of security.

## Step 4: Adding health check to Spring Boot backend

Add support for health checks in the Spring Boot application. In the `pom.xml` file, add the following dependency:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Then we can make use of the actuator endpoints to monitor the health of the application. This exposes the endpoint `GET /actuator/health`.

In the `docker-compose.prod.yml` file, add a health check to the app service:

```yaml
services:
  app:
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:8080/actuator/health >/dev/null 2>&1 || exit 1"]
      interval: 5s
      timeout: 2s
      retries: 2
      start_period: 10s
```

Then we make the nginx service depend on the app service:

```yaml
services:
  nginx:
    depends_on:
      app:
        condition: service_healthy
```

## Step 4: Testing the setup

To start the services, use the following command to start the containers in detached mode:

```bash
docker compose -f docker-compose.prod.yml up -d
```

Note that the `-f` flag is used to specify the compose file to use.

Check if the containers are running:

```bash
docker ps -a
```

If everything is running correctly, you should see the containers listed.

Test the setup by sending a request to the nginx reverse proxy:

```bash
curl http://localhost/api/messages
```

You should see the response from the app service.

**If you encounter any issues, check the logs of the nginx container or the app container:**

```bash
docker compose -f docker-compose.prod.yml logs nginx
```

```bash
docker compose -f docker-compose.prod.yml logs app
```

## Step 5: Tear down

To stop and remove the containers, use the following command:

```bash
docker compose -f docker-compose.prod.yml down -v
```
