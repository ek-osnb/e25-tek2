# Adding TLS to our nginx server

In this exercise, you will learn how to secure your nginx web server with HTTPS using a self-signed TLS certificate.

## Step 1: Install certbot

**1. SSH into your server.**

SSH into `server1` (this is where nginx is running):

```
ssh appuser@<public-ip-of-server1>
```

**2. Install certbot using the package manager for your operating system. For example, on Ubuntu**

```
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx -y
```
- This installs certbot and the nginx plugin for certbot (which allows certbot to automatically configure nginx for HTTPS).

**3. Verify the installation by checking the certbot version:**

```
certbot --version
```
## Step 2: Getting a certificate

**1. Run the following command to obtain a self-signed TLS certificate for your domain:**

```
sudo certbot --nginx -d your_domain.dk -d www.your_domain.dk
```
**Replace `your_domain.dk` with your actual domain name.**

Follow the prompts to complete the certificate issuance process. Certbot will automatically configure nginx to use the new certificate and update your server block to listen on port 443 for HTTPS traffic using `https://your_domain.dk`.

### Errors while obtaining certificate
- If you encounter an error :`Could not automatically find a matching server block for your_domain.dk. Set the server_name directive to use the Nginx installer` - you need to update your nginx configuration file to include the correct `server_name` directive for your domain.
- After this, you can run:
    ```bash
    certbot install --cert-name your_domain.dk
    ```


### What certbot did:
- Configured nginx to use the obtained TLS certificate.
- Set up automatic redirection from HTTP to HTTPS.

The TLS certificate and private key are stored in the following locations:
- Certificate: `/etc/letsencrypt/live/your_domain.dk/fullchain.pem`
- Private Key: `/etc/letsencrypt/live/your_domain.dk/privkey.pem`

**3. Open firewall for HTTPS traffic:**

To allow for HTTPS traffic, run the following command:
```
sudo ufw allow https/tcp
```

## Step 3: Testing your HTTPS setup
Open your web browser and navigate to `https://your_domain.dk`.

You should see a secure connection indicated by a padlock icon in the address bar. If you click on the padlock, you can view the details of the TLS certificate.

**Congratulations! You have successfully set up HTTPS on your nginx server.**

## Step 4: Nginx configuration

### Naming nginx configuration files

**It is good practice to name the nginx configuration files according to the domain they are serving. You can rename your existing configuration file as follows:**

```bash
sudo mv /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-available/your_domain.dk.conf
```
Replace `your_domain.dk` with your actual domain name.

**Then, update the symbolic link in the `sites-enabled` directory:**

```bash
sudo ln -sf /etc/nginx/sites-available/your_domain.dk.conf /etc/nginx/sites-enabled/your_domain.dk.conf
```

**Delete the old symbolic link:**

```bash
sudo rm /etc/nginx/sites-enabled/reverse-proxy.conf
```

**Test the nginx configuration for syntax errors:**

```bash
sudo nginx -t
```

**Restart Nginx to apply the changes:**

```bash
sudo systemctl restart nginx
```

### Changing the server_name directive

**Open the nginx configuration file for your domain:**

```bash
sudo nano /etc/nginx/sites-available/your_domain.dk.conf
```

**Update the `server_name` directive to match your domain:**

Replace the `_` wildcard or IP address with your actual domain names:

```nginx
server {
    server_name your_domain.dk www.your_domain.dk;
    ...
}
```

This ensures that the server block correctly responds to requests for your domain, and that our server doesn't respond to requests for the IP address.


### Redirecting to `www` (Optional)

To redirect all `your_domain.dk` traffic to `www.your_domain.dk`.

We want the following behavior:
- `http://your_domain.dk` redirect to: `https://www.your_domain.dk` (301 redirect).
- `http://www.your_domain.dk` redirect to: `https://www.your_domain.dk` (301 redirect).
- `https://your_domain.dk` redirect to: `https://www.your_domain.dk` (301 redirect).
- `https://www.your_domain.dk` serves content (200 OK).


We need to change the nginx configuration file for our domain

```bash
sudo nano /etc/nginx/sites-available/your_domain.dk.conf
```

Paste the following configuration into the file:

```nginx
# 1
server {
    listen 80;
    server_name your_domain.dk www.your_domain.dk;
    return 301 https://www.your_domain.dk$request_uri;
}

# 2
server {
    listen 443 ssl;
    server_name your_domain.dk;

    ssl_certificate     /etc/letsencrypt/live/your_domain.dk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain.dk/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    return 301 https://www.your_domain.dk$request_uri;
}

# 3
server {
    listen 443 ssl;
    server_name www.your_domain.dk;

    ssl_certificate     /etc/letsencrypt/live/your_domain.dk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your_domain.dk/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
````
**Replace `your_domain.dk` with your actual domain name.**

**Explanation:**
1. The first server block listens on port 80 (HTTP) for both `your_domain.dk` and `www.your_domain.dk`, and redirects all requests to `https://www.your_domain.dk`.
2. The second server block listens on port 443 (HTTPS) for `your_domain.dk` and redirects all requests to `https://www.your_domain.dk`:
3. The third server block listens on port 443 (HTTPS) for `www.your_domain.dk` and serves the actual content.


**Test the nginx configuration for syntax errors:**

```bash
sudo nginx -t
```
**Restart Nginx to apply the changes:**

```bash
sudo systemctl restart nginx
```

**Test if the redirections are working as expected by visiting:**
- `http://your_domain.dk`
- `http://www.your_domain.dk`
- `https://your_domain.dk`
- `https://www.your_domain.dk`

You can use the devtools in your browser to check the network requests and confirm that the redirections are functioning correctly.

### Why redirect to `www`?
Using `www` redirection can help with:
- **Consistency:** Ensures that all users access the website through a single, standardized URL format.
- **SEO:** Prevents duplicate content issues by consolidating all traffic and link equity under one canonical domain.
- **Cookies:** Provides better cookie management — cookies set on `www.your_domain.dk` won’t automatically be sent to `your_domain.dk`, and vice versa (unless explicitly configured).

Additionally, if you later deploy to other cloud providers or use a CDN, they often expect the `www` subdomain to be the main entry point for the website. This approach offers greater flexibility for routing, load balancing, and traffic management.