# Docker: Bind mounts

When we run containers, the filesystem is isolated from the host machine. This means that any changes made to the filesystem inside the container will not affect the host filesystem, and vice versa. However, there are times when you may want to share files between the host and the container. This is where bind mounts and volumes come into play.

## Bind mounts

A bind mount is a mapping between a host file or directory and a container file or directory. This allows you to share files between the host and the container, and any changes made to the files will be reflected in both places.

### Step 1: Creating a directory to share

Make sure that you have stopped the nginx container, that you have previously created.

First, we need to create a directory that we want to share with the container. Open up your terminal and run the following command:

```bash
mkdir -p tek2/nginx-example
```
This will create the directory `tek2/nginx-example` on your host machine.

<!-- Navigate to the `tek2/nginx-example` directory:

```bash
cd tek2/nginx-example
``` -->

### Step 2: Creating a bind mount

To create a bind mount, you can use the `-v` option with the `docker run` command:

```bash
docker run -d --name my-nginx -p 8090:80 -v ./tek2/nginx-example:/usr/share/nginx/html:ro nginx
```

The `./tek2/nginx-example` tells that we want to map everything inside the `nginx-example` directory to the `/usr/share/nginx/html` directory inside the container. The `:ro` option (optional) makes the container's view of the files **read-only** - ie. the files cannot be modified from within the container.

Any files placed in the host directory (`./tek2/nginx-example`) will be accessible inside the container.

### Step 3: Adding files to the shared directory

Now that we have our bind mount set up, we can add files to the `./tek2/nginx-example` directory on the host machine. These files will be automatically available inside the container at `/usr/share/nginx/html`.

Add an `index.html` file to the `./tek2/nginx-example` directory with the following content:

```html
<!DOCTYPE html>
    <html>
        <head>
            <title>My Nginx Page</title>
        </head>
        <body>
            <h1>Hello from Nginx using Docker!</h1>
    </body>
</html>
```

To test that the bind mount is working, you can open a web browser and navigate to `http://localhost:8090`. You should see the contents of the `index.html` file that you created earlier (if not try opening the browser in incognito mode).

## Volumes

Volumes are a more flexible way to manage data in Docker. Unlike bind mounts, which are tied to a specific host path, volumes are managed by Docker and can be easily shared between containers.

### Step 1: Creating a volume

To create a volume, you can use the `docker volume create` command:

```bash
docker volume create nginx-data
```

You can see a list of all your volumes by running the following command:

```bash
docker volume ls
```

### Step 2: Using the volume

Once the volume is created, you can use it with the `-v` option when running a container:

```bash
docker run --rm -d -p 8095:80 --name web -v nginx-data:/usr/share/nginx/html nginx
```

In this example, the `nginx-data` volume is mounted to the `/usr/share/nginx/html` directory inside the container.


### Step 3: Adding files to the volume

Now that we have our volume set up, we can add files to the `nginx-data` volume. You can do this by running a temporary container that mounts the volume and allows you to copy files into it:

```bash
docker cp ./tek2/nginx-example/index.html nginx-data:/usr/share/nginx/html/
```

This will add the file to the `nginx-data` volume.

Verify by opening a web browser and navigating to `http://localhost:8095`. You should see the contents of the `index.html` file that you created earlier (if not try opening the browser in incognito mode).


### Step 4: Restarting the container

Stop the container:

```bash
docker stop web
```

Now run the container again:

```bash
docker run --rm -d -p 8095:80 --name web -v nginx-data:/usr/share/nginx/html nginx
```

Note that the contents of the `nginx-data` volume will persist even if the container is stopped or removed.
