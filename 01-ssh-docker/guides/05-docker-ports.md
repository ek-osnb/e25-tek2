# Docker: Exposing Ports

When running Docker containers, you may need to expose ports to allow communication between the container and the host machine or other containers. This is especially important for web applications and services.

We will try to expose a port for a simple nginx web server.

## Step 1: Exposing Ports at Runtime

To expose a port when starting a container, use the `-p` flag followed by the port mapping in the format `<host_port>:<container_port>`. For example, to expose port 80 of a web server running in a container to port 8080 on the host, you would run:

```bash
docker run -p 8090:80 nginx
```

This command will pull the `nginx` image from Docker Hub (if not already present) and run a new container with port `8090` exposed.

## Step 2: Interacting with the Web Server

Once the container is running, you can interact with the web server by opening a web browser and navigating to `http://localhost:8090`. You should see the default nginx welcome page.

You can also use `curl` to test the web server from the command line:

```bash
curl http://localhost:8090
```

## Step 3: Stopping the Web Server

To stop the running nginx container, you can use `CTRL+C` in the terminal where the container is running. This will gracefully stop the nginx web server running in the container.


## Step 4: Removing the Container

If you want to remove the container completely after stopping it, you first need to get the containers ID:
```bash
docker ps -a
```

This will list all containers, including stopped ones. Find the container ID or name of the nginx container you want to remove.

Once you have the container ID or name, you can use the `docker rm` command:

```bash
docker rm <container_id_or_name>
```

This will delete the stopped container from your system.

## Step 5: Running in detached mode

To run a container in detached mode (in the background), you can use the `-d` flag:

```bash
docker run -d -p 8090:80 nginx
```

This command will start the nginx container in detached mode, allowing you to continue using your terminal while the container runs in the background.

Try accessing the web server again by navigating to `http://localhost:8090` in your web browser or using `curl`:

```bash
curl http://localhost:8090
```

## Step 6: Removing a container in detached mode

When a container is running in detached mode, you need to first stop the container before removing it. You can stop the container using the `docker stop` command followed by the container ID or name:

```bash
docker stop <container_id_or_name>
```

Once the container is stopped, you can remove it using the `docker rm` command:

```bash
docker rm <container_id_or_name>
```
