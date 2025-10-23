# Setting up Nginx as a reverse proxy

## Step 1: Install Nginx

On `vm1`, install Nginx if it's not already installed:

```bash
sudo apt update
sudo apt install nginx -y
```

Make sure Nginx is running:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

The `systemctl enable nginx` command ensures that Nginx starts automatically on boot.

## Step 2: Configure Nginx as a reverse proxy

Nginx needs to be configured to forward incoming requests to the application running on `vm1`.

<!-- SSH into `vm1` and create a new Nginx configuration file for the reverse proxy:

```bash
ssh appuser@<public-ip-of-vm1>
``` -->

Create a new configuration file:

```bash
sudo nano /etc/nginx/sites-available/reverse-proxy.conf
```

Add the following **server block** to the file:

```nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

This will listen on port 80 and forward requests to the application running on `localhost:8080`.

## Step 3: Enable the Nginx configuration

The directory `/etc/nginx/sites-available/` contains available site configurations, while `/etc/nginx/sites-enabled/` contains symlinks to the configurations that are currently enabled.

A symlink (symbolic link) is a type of file that points to another file or directory. It acts as a shortcut, allowing you to access the target file or directory from a different location in the filesystem. Nginx uses this mechanism to manage which site configurations are active, making it easy to enable or disable sites without modifying the actual configuration files.

First remove the default symlink if it exists:

```bash
sudo rm /etc/nginx/sites-enabled/default
```

Then create a symlink to enable the new configuration:

```bash
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
```

## Step 4: Test and restart Nginx

Every time we make changes to the Nginx configuration, we should test it for syntax errors:

```bash
sudo nginx -t
```

If the test is successful, restart Nginx to apply the changes:

```bash
sudo systemctl restart nginx
```

## Step 5: Test the reverse proxy

On the ´VM1´, use `curl` to test if the reverse proxy is working:

```bash
curl http://localhost/api/hello
curl http://localhost/api/books
```

You should see the responses from the backend application. By default this uses port 80, so you don't need to specify it in the URL.

## Step 6: Accessing from outside

Try accessing the application from your local machine using the public IP address of `vm1`:

```bash
curl http://<public-ip-of-vm1>/api/hello
curl http://<public-ip-of-vm1>/api/books
```

## Summary

In this exercise, we installed and configured Nginx as a reverse proxy on `vm1`. We set up Nginx to forward incoming HTTP requests on port 80 to the backend application running on `localhost:8080`. We also tested the configuration to ensure that the reverse proxy is functioning correctly.