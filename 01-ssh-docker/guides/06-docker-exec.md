# Docker: Executing Commands in a Running Container

Sometimes you may need to execute commands inside a running Docker container, without disturbing the running process. This can be useful for debugging, troubleshooting, or performing administrative tasks.

## Step 1: Start an nginx Container in detached mode

To start an nginx container, you can use the following command:

```bash
docker run -d --name my-nginx -p 8090:80 nginx
```

This command will start a new nginx container in detached mode, mapping port `8090` on the host to port `80` in the container, and give the custom name `my-nginx` to the container.

## Step 2: Tapping into the container

To execute commands inside the running `my-nginx` container, without disturbing the running process, you can use the `docker exec` command.

To list files inside the container, you could run:

```bash
docker exec -it my-nginx ls
```
- You can use either the container name or the container ID to reference the container.

But this may not be that useful, as you might want to run more complex commands inside the container. So instead we want to open a bash shell:

```bash
docker exec -it my-nginx bash
```

This will give you an interactive shell inside the container, where you can run any command as if you were logged into the container's operating system. For example, you could update packages, modify configuration files, or inspect logs. When you're done, you can type `exit` to leave the shell and return to your host system.

## Step 3: Updating packages inside the container

Once you have a shell inside the container, you can update the package lists and upgrade the installed packages just like you would on a regular Linux system. For example, to update the package lists and upgrade all packages in an Ubuntu-based container, you could run:

```bash
apt update
apt upgrade
```

Keep in mind that changes made inside the container will not persist if the container is removed.

## Step 4: Installing packagess inside the container

When inside the container, try installing a text editor like `vim` or `nano`:

```bash
apt install vim
```

or

```bash
apt install nano
```

This will allow you to edit files within the container using your preferred text editor.

## Step 5: Changing webcontent inside the nginx webserver

To change the web content served by the nginx server, you need to modify the files in the `/usr/share/nginx/html` directory inside the container. You can use your preferred text editor (`nano` is the easiest) to edit these files.

First you need to access the shell inside the container:

```bash
docker exec -it my-nginx bash
```

For example, to change the default `index.html` file, you could run:

```bash
nano /usr/share/nginx/html/index.html
```

This will open the `index.html` file in the `nano` text editor. 

Try changing the content of the `<h1>`-tag to something like:

```html
<h1>Hello from my-nginx container!</h1>
```

To save the changes, press `CTRL+X`, then `Y`, and finally `ENTER`.

## Step 6: Verifying the changes

After making changes to the `index.html` file, you can verify that the changes have taken effect by accessing the web page in your browser. Navigate to `http://localhost:8090` and you should see the updated content.