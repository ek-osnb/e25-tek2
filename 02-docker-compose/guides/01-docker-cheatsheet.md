# Docker Cheatsheet

## Documentation
- [Docker Docs](https://docs.docker.com/)

## Images
- `docker pull <image_name>` — Download an image from Docker Hub  
- `docker images` — List all images on your system  
- `docker rmi <image_name>` — Remove an image  
- `docker build -t <tag_name> .` — Build an image from a Dockerfile in the current directory  
- `docker tag <image_name> <new_name>:<tag>` — Add a new tag to an existing image  

## Containers
- `docker run --name <container_name> <image_name>` — Create and run a container with a custom name  
- `docker run -p <host_port>:<container_port> <image_name>` — Run a container and map ports from host → container  
- `docker run -d <image_name>` — Run a container in the background (detached)  
- `docker start|stop <container_name>` — Start or stop an existing container  
- `docker rm <container_name>` — Remove a stopped container  
- `docker exec -it <container_name> sh` — Open a shell inside a running container  
- `docker logs -f <container_name>` — View and follow container logs  
- `docker inspect <container_name>` — Inspect details about a container  
- `docker ps` — List running containers  
- `docker ps -a` — List all containers (running + stopped)  


## Volumes
- `docker volume ls` — List volumes  
- `docker volume create <volume_name>` — Create a volume  
- `docker volume rm <volume_name>` — Remove a volume  
- `docker run -v <volume_name>:<path_in_container> <image_name>` — Mount a named volume  
- `docker run -v $(pwd):<path_in_container> <image_name>` — Mount the current host directory (bind mount)  

## Networks
- `docker network ls` — List networks  
- `docker network create <network_name>` — Create a custom network  
- `docker network rm <network_name>` — Remove a network  
- `docker run --network <network_name> <image_name>` — Run a container attached to a specific network  
- Containers on the same custom network can talk to each other using their **container names** as hostnames  

## Compose
- `docker compose up` — Start all services defined in `docker-compose.yml`  
- `docker compose up -d` — Start in detached mode (background)  
- `docker compose down` — Stop and remove all services from the compose file  
- `docker compose build` — Build/rebuild images defined in the compose file  
- `docker compose logs -f <service>` — Follow logs of a specific service  
- `docker compose exec <service> sh` — Open a shell in a running service container  
- `docker compose ps` — List running services in the compose project  


## Tips
- Use `.dockerignore` to exclude files from builds.
- In Compose, `depends_on` controls startup order, but use **healthchecks** for readiness.  
- Use `127.0.0.1:host_port:container_port` to bind a service only to localhost (dev).
