# Docker: Cleaning up containers and images


## Step 1: Removing a single stopped container
You will notice that if you run:
```bash
docker ps -a
```
that you have several stopped containers. To remove these stopped containers, you can use the following command:
```bash
docker rm <container_id>
```
Replace `<container_id>` with the actual ID of the container you want to remove. You can also remove multiple containers at once by specifying their IDs separated by spaces.


## Step 2: Removing all stopped containers

If you want to remove all stopped containers, you can use:
```bash
docker container prune
```
This command will prompt you for confirmation before deleting all stopped containers.


## Step 3: Removing unused images

In addition to cleaning up containers, you may also want to remove unused images. You can list all images on your system with:
```bash
docker images
```
To remove an unused image, use:
```bash
docker rmi <image_id>
```
Again, replace `<image_id>` with the actual ID of the image you want to remove.



To remove all unused images, you can use:
```bash
docker image prune
```
This command will also prompt you for confirmation before deleting all unused images (this only cleans up dangling images).

By regularly cleaning up stopped containers and unused images, you can free up disk space and keep your Docker environment tidy.

## Step 4: General cleanup

To perform a general cleanup of your Docker environment, you can use the following command:
```bash
docker system prune
```
This command will remove all stopped containers, all unused networks, all dangling images, and all build cache. It will prompt you for confirmation before proceeding.