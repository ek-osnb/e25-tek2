# Docker setup on Virtual Machines

## Step 1: Install Docker on both VMs

We can follow the official Docker installation guide for [Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) to install Docker on both `vm1` and `vm2`.

For now we will use this convenience script to install Docker (although it's recommended to follow the official guide as the script may not always be up to date).

Create a script file called `install-docker.sh` on your local machine with the following content:

```bash
#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

Then, transfer the script to both VMs and execute it:

```bash
scp install-docker.sh appuser@<public-ip-of-vm1>:/home/appuser/install-docker.sh
scp install-docker.sh appuser@<public-ip-of-vm2>:/home/appuser/install-docker.sh
```
Then, SSH into each VM and run the script:

```bash
ssh appuser@<public-ip-of-vm1>
chmod 700 install-docker.sh
./install-docker.sh
```
Check that Docker is installed correctly by running:

```bash
sudo systemctl status docker
```
You should see that the Docker service is active and running.

**Repeat the same steps for `vm2`.**

## Step 2: Run a Docker container on vm1

Now that Docker is installed on both VMs, we want to run the services on our virtual machines.

As an example, we will use this [repo](https://github.com/ek-osnb/spring-ghcr) as an example.
The `compose.yml` file defines two services: `app` (the backend) and `db` (the database).

As a first approach, we will make both services run on `vm1`. Create a new file called `compose.yml` on your local machine with the following content:

```yaml
services:
  db:
    image: mysql:8.0
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "127.0.0.1:3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 20s
      retries: 5

  app:
    image: ghcr.io/ek-osnb/spring-ghcr:latest
    restart: unless-stopped
    environment:
      SPRING_PROFILES_ACTIVE: ${SPRING_PROFILES_ACTIVE}
      SPRING_DATASOURCE_URL: ${SPRING_DATASOURCE_URL}
      SPRING_DATASOURCE_USERNAME: ${SPRING_DATASOURCE_USERNAME}
      SPRING_DATASOURCE_PASSWORD: ${SPRING_DATASOURCE_PASSWORD}
    ports:
      - "127.0.0.1:8080:8080"
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: [ "CMD-SHELL", "wget -qO- http://localhost:8080/actuator/health >/dev/null 2>&1 || exit 1" ]
      interval: 5s
      timeout: 2s
      retries: 2
      start_period: 10s

volumes:
  db_data:
```
Transfer the `compose.yml` file to `vm1`:

```bash
scp compose.yml appuser@<public-ip-of-vm1>:/home/appuser/compose.yml
```
The environment variables can be set in a `.env` file. Create a file called `.env` on `vm1` with the following content:

```bash
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydb
MYSQL_USER=user
MYSQL_PASSWORD=secret
SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/$MYSQL_DATABASE
SPRING_DATASOURCE_USERNAME=user
SPRING_DATASOURCE_PASSWORD=secret
SPRING_PROFILES_ACTIVE=docker
```

You can create the file directly on `vm1` using `nano` or `vim`.

Now, run the Docker Compose setup on `vm1`:

```bash
sudo docker compose up -d
```
This will start both the `db` and `app` services in detached mode, and may take a few minutes to download the necessary images and start the containers, and starting the containers.

You can check the status of the containers using:

```bash
sudo docker ps
```
You should see both `db` and `app` containers running.

### Checking the application endpoints:
You can check if the application is running by running a `curl` command from `vm1`:

```bash
curl http://localhost:8080/api/hello
curl http://localhost:8080/api/books
```

You should see the responses from the application.

**Note that since we are using `127.0.0.1` mappings inside the VMs, we are not exposing the services to the outside world - we will see later how to use nginx (reverse proxy) for this.**

## Step 3: Setting up the database on vm2

Instead of running both services on `vm1`, we can run the database service on `vm2` and have the application on `vm1` connect to it over the private network.

First we need to check the private IP address of `vm2`. You can find it by running the following command on `vm2`:

```bash
ip addr show eth1
```
Typically, the private IP will be in the `10.110.x.x` range.

On `vm2`, create a new `compose.yml` file with the following content:

```yaml
services:
  db:
    image: mysql:8.0
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
      - "${HOST_PRIVATE_IP}:${MYSQL_HOST_PORT}:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 20s
      retries: 5
volumes:
  db_data:
```

Create a `.env` file on `vm2` with the following content:

```bash
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydb
MYSQL_USER=user
MYSQL_PASSWORD=secret
MYSQL_HOST_PORT=3306
HOST_PRIVATE_IP=10.110.0.3
```
**Replace `10.110.0.3` with your actual private IP.**

Run the Docker Compose setup on `vm2`:

```bash
sudo docker compose up -d
```

Check that the database container is running:

```bash
sudo docker ps
```

## Step 4: Configure the application on vm1 to connect to the database on vm2


### Environment variable update
On `vm1`, we need to update the `.env` file to point the application to the database on `vm2`.

Edit the `.env` file on `vm1` and update the `SPRING_DATASOURCE_URL` variable to use the private IP address of `vm2`:

```bash
DB_HOST=10.110.0.3
DB_PORT=3306
DB_NAME=mydb
SPRING_DATASOURCE_URL=jdbc:mysql://$DB_HOST:$DB_PORT/$DB_NAME
SPRING_DATASOURCE_USERNAME=user
SPRING_DATASOURCE_PASSWORD=secret
SPRING_PROFILES_ACTIVE=docker
```
Replace with the actual private IP of `vm2`.

Stop the existing Docker Compose setup on `vm1`:

```bash
sudo docker compose down
```

### compose.yml update
Also, update the `compose.yml` file on `vm1` to remove the `db` service, since the database is now running on `vm2`. The updated `compose.yml` on `vm1` should look like this:

```yaml
services:
  app:
    image: ghcr.io/ek-osnb/spring-ghcr:latest
    restart: unless-stopped
    environment:
      SPRING_PROFILES_ACTIVE: ${SPRING_PROFILES_ACTIVE}
      SPRING_DATASOURCE_URL: ${SPRING_DATASOURCE_URL}
      SPRING_DATASOURCE_USERNAME: ${SPRING_DATASOURCE_USERNAME}
      SPRING_DATASOURCE_PASSWORD: ${SPRING_DATASOURCE_PASSWORD}
    ports:
      - "127.0.0.1:8080:8080"
    healthcheck:
      test: [ "CMD-SHELL", "wget -qO- http://localhost:8080/actuator/health >/dev/null 2>&1 || exit 1" ]
      interval: 5s
      timeout: 2s
      retries: 2
      start_period: 10s
```
Now, start the Docker Compose setup again on `vm1`:

```bash
sudo docker compose up -d
```
Check that the application container is running:

```bash
sudo docker ps
```
### Testing the connection
You can test if the application on `vm1` can connect to the database on `vm2` by running the following `curl` commands from `vm1`:
```bash
curl http://localhost:8080/api/books
```
You should see the response from the application, indicating that it is successfully connected to the database on `vm2`.

## Summary
In this exercise, you installed Docker on two Virtual Machines, ran a database service on one VM, and an application service on another VM, connecting them over a private network. This setup is common in cloud environments to enhance security and performance by isolating services within a private network.

