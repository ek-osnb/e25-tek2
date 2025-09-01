# Docker compose: Enhancing the docker-compose setup

## Goal:

Improve the `docker-compose.yml` setup by adding restart policies to the services, adding Spring profiles support and we will look at port exposure.

## Step 1: Adding Spring Profiles

In Spring Boot we can use different profiles to manage environment-specific configurations. By default, Spring Boot uses the `application.properties` file for configuration. However, we can create separate configuration files for each profile, such as `application-dev.properties`, `application-test.properties`, and `application-prod.properties`.

Create a new file named `application-docker.properties` in the `src/main/resources` directory.

Inside `application-docker.properties` file, paste the following properties:
```properties
spring.config.activate.on-profile=docker

# MySQL Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/my_db?createDatabaseIfNotExist=true
spring.datasource.username=USER
spring.datasource.password=PASSWORD
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
spring.jpa.show-sql=true
```

Inside the `application.properties` file, paste the following properties:
```properties
spring.application.name=docker-spring

# H2 Database Configuration
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

spring.jpa.hibernate.ddl-auto=update
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
```

Now when we run our application locally (without docker), it will use the default H2 in-memory database configuration.


## Step 2: Configuring Docker Compose

To activate a specific profile, we can set the `SPRING_PROFILES_ACTIVE` environment variable in our `docker-compose.yml` file.

```yaml
services:
  app:
    environment:
      SPRING_PROFILES_ACTIVE: docker
```

This will activate the `docker` profile, and Spring Boot will load the configuration from `application-docker.properties`.

We could also add it to our `.env` file:
```env
SPRING_PROFILES_ACTIVE=docker
```

Then we could reference it inside the `docker-compose.yml` file:

```yaml
services:
  app:
    environment:
      SPRING_PROFILES_ACTIVE: ${SPRING_PROFILES_ACTIVE}
```

Try running your application with Docker Compose:
```bash
docker-compose up -d --build
```

The `--build` flag ensures that the images are rebuilt before starting the containers. This is neccesary when we make changes to the application code or the Dockerfile.

## Step 3: Adding Restart Policies

In case the application fails we want the services to restart automatically. We can achieve this by adding a `restart` policy section to our `docker-compose.yml` file.

```yaml
services:
  db:
    restart: unless-stopped

  app:
    restart: unless-stopped
```

This configuration will ensure that the `app` and `db` services are restarted automatically if they fail. This is particularly useful in production environments where we want to minimize downtime. If we manually stop the containers, they will not be restarted until we explicitly start them again.

Run the following command to start the services:
```bash
docker-compose up -d --build
```

## Step 4: Restricting Port Exposure

### About Port Exposure

So far, we have mapped the following ports:

- `8080:8080` for the `app` service  
- `3307:3306` for the `db` service  

By default, this binds to all host interfaces (`0.0.0.0`), which means these ports are [reachable from **any network interface** on the host](https://docs.docker.com/engine/network/#published-ports). If your machine is on a LAN or connected to the Internet without a firewall, other machines could potentially connect to your services — not what you want in most cases.

To lock this down, we can bind the ports to **localhost only** (`127.0.0.1`). This ensures the services are only accessible from the host machine itself.


The only downside is, that now the service is not accessible to external clients.

So depending on the use case, this might be a limitation. If external access is required, we need to find a balance between security and accessibility.

---

### Task

Add `127.0.0.1` to both service ports:

```yaml
services:
  app:
    ports:
      - "127.0.0.1:8080:8080"
  db:
    ports:
      - "127.0.0.1:3307:3306"
```

This will make both services only accessible from the localhost (127.0.0.1) interface which enhances security by preventing external access in development environments.

### Production considerations (extra)
In a production environment, you would typically not expose the database port at all. Instead, the application would connect to the database over an internal network or a private network interface. The backend services are also not exposed directly, and access is controlled through a reverse proxy or API gateway. An example of a reverse proxy configuration could involve using Nginx to route requests to the appropriate service based on the request URL.
