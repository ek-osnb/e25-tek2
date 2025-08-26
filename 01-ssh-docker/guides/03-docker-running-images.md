# Docker: Running your first container

In this guide, you will learn how to run your first container (Alpine Linux) using Docker.

## Step 1: Pull a Docker Image

Before you can run a container, you need to have a Docker image. You can pull an image from Docker Hub using the following command:

```bash
docker pull alpine
```
- This command will download the latest Alpine Linux image from Docker Hub.


## Step 2: Listing Docker Images

You can list all the Docker images on your system using the following command:

```bash
docker images
```

This command will display a list of all images, including the Alpine image you just pulled:
```bash
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
hello-world         latest    a0dfb02aac21   2 weeks ago     16.9kB
alpine              latest    4bcff63911fc   6 weeks ago     13.3MB
```

## Step 3: Running a Docker container

To run the Docker container based on the Alpine image, you can use the following command:
```bash
docker run alpine ls -l
```
This command will start a new container from the Alpine image and execute the `ls -l` command inside the container, listing the files in the root directory, you should get an output like:
```bash
total 56
drwxr-xr-x    2 root     root          4096 Jul 15 10:42 bin
drwxr-xr-x    5 root     root           340 Aug 26 20:51 dev
drwxr-xr-x    1 root     root          4096 Aug 26 20:51 etc
drwxr-xr-x    2 root     root          4096 Jul 15 10:42 home
drwxr-xr-x    6 root     root          4096 Jul 15 10:42 lib
drwxr-xr-x    5 root     root          4096 Jul 15 10:42 media
```

You can also run:

```bash
docker run -it alpine echo "Hello, World!"
```
This will give you the output:

```bash
Hello, World!
```

## Step 4: Running a container interactively

If you run:

```bash
docker run alpine /bin/sh
```
Nothing will happen. This is because the container will exit after running the command `/bin/sh`.

If you want to run the container interactively, you can use the `-it` flag:

```bash
docker run -it alpine /bin/sh
```

You are now inside the Alpine container shell, and now you can run commands inside the container. Try running:

```bash
ls -l
```


## Step 5: Exiting a container 

To exit the container, you can simply type `exit`. This will stop the container and return you to your host terminal.

```bash
exit
```

## Step 6: Listing running containers

To list all running containers, you can use the following command:

```bash
docker ps
```

But you will notice that you have no running containers. This is because you stopped the container after exiting the container.

If you want to see all containers (including stopped ones), you can use:

```bash
docker ps -a
```

You will see something like:

```bash
CONTAINER ID   IMAGE     COMMAND      CREATED              STATUS                           PORTS   NAMES
d248e97aac03   alpine    "/bin/sh"    About a minute ago   Exited (0) About a minute ago            hungry_torvald
05336b5efb89   alpine    "/bin/sh"    6 minutes ago        Exited (0) 6 minutes ago                 vibrant_gould
```
- The `STATUS` column shows that the containers have exited, meaning they are no longer running. The `(0)` indicates that the containers exited without any errors.
- The `CONTAINER ID` column shows the unique identifier for each container, which can be used to reference the container in other Docker commands.


## Step 7: Naming your container
To set a specific name for your container, you can use the `--name` flag when running the container:

```bash
docker run --name my-alpine-container alpine
```