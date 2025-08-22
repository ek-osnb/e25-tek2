# Docker ports & bind mounts

In this guide, we will explore how to use **ports** and **bind mounts**.

Ports are used to expose services running inside a Docker container to the host machine, allowing you to access them from outside the container.

Bind mounts allow you to mount a directory from your host machine into a Docker container, enabling real-time file sharing between the host and the container. 

We will use the `nginx` (webserver) image as an example, but the concepts can be applied to any Docker image.

## Step 1: Create a Dockerfile
Create a file named `Dockerfile` in your project directory with the following content:
```dockerfile
# Use the official Nginx image as the base image
FROM nginx:alpine

# COPY INDEX.HTML
COPY index.html /usr/share/nginx/html/index.html

```

## Step 2: Create an HTML file
Create a file named `index.html` in the same directory with the following content:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Nginx Site</title>
</head>
<body>
    <h1>Hello from Nginx!</h1>
</body>
</html>
```

## Step 3: Build the Docker image
Open a terminal in the directory containing your `Dockerfile` and run the following command to build the Docker image:
```bash
docker build -t nginx-example .
```
This command will create a Docker image named `nginx-example`.

## Step 4: Run the Docker container (without bind mount)

To run the Docker container with a port mapping, use the following command:
```bash
docker run --name nginx-example -p 8080:80 -d nginx-example
```
- `--name nginx-example`: Names the container `nginx-example`.
- `-p 8080:80`: Maps port 8080 on your host to port 80 in the container.
- `-d`: Runs the container in detached mode (in the background).
- `nginx-example`: The name of the image you built.

## Step 5: Verify the content
Open your web browser and go to `http://localhost:8080`. You should see the content of the `index.html` file you created earlier.

## Step 6: Change the HTML file on your host machine
Now, let's modify the `index.html` file in the same directory where your `Dockerfile` is located. Change the `<h1>` tag content to:
```html
<h1>Changed content from host machine!</h1>
```

## Step 7: Check the changes in browser
Open your web browser and refresh the page at `http://localhost:8080`. Notice that the content was not updated! This is because the container is using the `index.html` file that was copied during the build process, and it does not reflect changes made on the host machine.

## Step 8: Stop and remove the container
To see the changes in real-time, you can run the container with a bind mount. This allows you to map a directory from your host machine to a directory in the container. 

First stop the running container:
```bash
docker stop nginx-example
```

Then remove the container:
```bash
docker rm nginx-example
```

## Step 9: Run the container with a bind mount
Now, let's run the container again, but this time with a bind mount to the current directory:

```bash
docker run --name nginx-example -p 8080:80 -v "$(pwd):/usr/share/nginx/html" -d nginx-example
```
- `-v "$(pwd):/usr/share/nginx/html"`: This option mounts the current directory (where your `index.html` file is located) to the Nginx container's default HTML directory. This allows you to edit the `index.html` file on your host machine and see the changes reflected in the container immediately.

## Step 10: Verify the changes
Now, let's verify that the bind mount is working correctly. Open your web browser and go to `http://localhost:8080`. You should see the content of the `index.html` file you created earlier.

Try changing the content of the `index.html` file again, and refresh the page in your browser. You should see the updated content immediately without needing to rebuild the Docker image.

## Step 11: Stop and remove the container and images
When you are done testing, you can stop and remove the container again and image.

### Stop the container:
```bash
docker stop nginx-example
```

### Remove the container:
```bash
docker rm nginx-example
```

### Remove the image:
```bash
docker rmi nginx-example
```

