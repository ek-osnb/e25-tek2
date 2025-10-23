---
marp: true
title: "Cloud VM's & continuous deployment"
version: "1.0"
paginate: true
---

<!-- _class: lead -->

# Deployment

<style>
section.lead h1 {
  text-align: center;
  font-size: 2.5em;
}
section.lead h3 {
  text-align: center;
  opacity: 0.6;
}
</style>

---

# Goal

![Cloud infrastructure](assets/cloud-vm-ex1.png)

---

# Follow along
1. Create a VPC network
2. Create a VM with DigitalOcean
3. Set up an `appuser` user with SSH access
4. Install Docker
5. Running the containers
6. Setting up nginx as a reverse proxy

---

# 1. Create a VPC network

We will create a VPC network to host our VMs.
- **Region:** AMS3 (Amsterdam 3)
- **IP range:** Auto assign
- **Name:** `vpc-api`

---
# 2 Create a VM with DigitalOcean

We will start from scratch and create two new VMs.
- **AMS3** region (Amsterdam 3)
- **Network:** `vpc-api`
- **OS:** Latest version of Ubuntu
- **Plan:** 2 X 2GB RAM, 1 vCPU ~12$/month
- **Authentication:** SSH key
- **Name:** `server1` (for Spring Boot) and `server2` (for Database)

---

# 2.1 Wait for the VMs to be created
Once the VMs are created, you will see them listed in the "Droplets" section.
- The VMs are assigned a public and private IP address
- Use the **public IP** to connect to the VMs from your local machine
- Use the **private IP** to connect between the VMs

---

# 2.2 SSH into the VMs

**Open two terminals, one for each VM**

```bash
ssh root@<public-ip-of-server1>
```

---


# 3.1 Create an new user: `appuser`

**Create the user with a home directory and `bash` shell**

```bash
useradd -m -s /bin/bash appuser
```
**Add a password for the user**

```bash
passwd appuser
```

**Create a .ssh directory for the new user:**

```bash
mkdir /home/appuser/.ssh
```

---

# 3.1 Set up SSH access for `appuser`

**Copy the root user's SSH public key to the new user's authorized_keys file:**

```bash
cat /root/.ssh/authorized_keys > /home/appuser/.ssh/authorized_keys
```

**Set the correct ownership and permissions:**
```bash
chown -R appuser:appuser /home/appuser/.ssh
chmod 700 /home/appuser/.ssh
chmod 600 /home/appuser/.ssh/authorized_keys
```

---

# 3.2 Granting sudo privileges to `appuser`

**Add `appuser` to the `sudo` group:**

```bash
usermod -aG sudo appuser
```
- `-aG`: append the user to the group without removing from other groups

---

# 3.3 Test SSH access for `appuser`

**From your local machine, SSH into the VM as `appuser`:**
Exit the current SSH sessions (type `exit`), then run:
```bash
ssh appuser@<public-ip-of-server1>
```
**Test whoami and sudo access:**
```bash
whoami
sudo whoami
```
- It prompts for the password you set earlier

---

# 3.4 Allow `appuser` to use sudo without password

**Edit the sudoers file:**
```bash
sudo visudo
```
**Add the following line at the end of the file:**
```bash
appuser ALL=(ALL:ALL) NOPASSWD:ALL
```
- NOPASSWD:ALL: no password required for all commands

**Save and exit the editor (type `ESC` and `:wq` and press Enter)**

---

# 4. Install Docker - From a script

On both VMs, download the Docker installation script:

```bash
wget https://raw.githubusercontent.com/ek-osnb/e25-tek2/main/05-cloud/exercises/scripts/docker-setup.yml -O docker-setup.yml
```
**Change ownership to `appuser`:**

```bash
sudo chown appuser:appuser docker-setup.yml
```

**Make the script executable:**

```bash
chmod 700 docker-setup.yml
```
**Run the script:**

```bash
sudo ./docker-setup.yml
```

---

# 4.1 Verify Docker installation

**Check if Docker is installed correctly:**

```bash
sudo systemctl status docker
```

---

# 5. Running the containers - download compose and .env files

We will start with `server2` (Database):

**Download the `compose.yml` file:**

```bash
wget https://raw.githubusercontent.com/ek-osnb/e25-tek2/main/05-cloud/exercises/scripts/db/compose.yaml -O compose.yml
```

**Download the `.env` file:**

```bash
wget https://raw.githubusercontent.com/ek-osnb/e25-tek2/main/05-cloud/exercises/scripts/db/.env-sample -O .env
```

---

# 5.1 Setting the correct private IP in the .env file

**Copy the private IP address of `server2`.**

**Paste the private IP address of `server2` into the `DB_HOST` variable in the `.env` file.**

You can use `nano` or `vim` to edit the file:
```bash
nano .env
```
Save and exit the file.

---

# 5.2 Run the database container

**Run the database container using Docker Compose:**

```bash
sudo docker compose up -d
```

**Check that the container is running:**

```bash
sudo docker ps
```

---

# 5.3 - Setting up `server1` (Spring Boot app)

Log into `server1`:
```bash
ssh appuser@<public-ip-of-server1>
```
**Download the `compose.yml` file:**

```bash
wget https://raw.githubusercontent.com/ek-osnb/e25-tek2/main/05-cloud/exercises/scripts/app/compose.yaml -O compose.yml
```

**Download the `.env` file:**

```bash
wget https://raw.githubusercontent.com/ek-osnb/e25-tek2/main/05-cloud/exercises/scripts/app/.env-sample -O .env
```

---

# 5.4 Setting the correct private IP in the .env file

**Paste the private IP address of `server2` into the `DB_HOST` variable in the `.env` file.**
You can use `nano` or `vim` to edit the file:
```bash
nano .env
```
**Save and exit the file.**

---

# 5.5 Run the Spring Boot app container

**Run the application container using Docker Compose:**

```bash
sudo docker compose up -d
```
Check that the container is running:

```bash
sudo docker ps
```

---

# 5.6 Test the application

**Test that the endpoints are working from within `server1`:**

```bash
curl http://127.0.0.1:8080/api/hello
curl http://127.0.0.1:8080/api/books
```

---

# 6. Setting up nginx as a reverse proxy

**On `server1`, update the apt package index and install Nginx:**

```bash
sudo apt update
sudo apt install nginx -y
```

**Start and enable Nginx to run on boot:**

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

![nginx files](assets/nginx-files.png)

---

# 6.1 Remove default Nginx configuration

**Remove default Nginx configuration:**

```bash
sudo rm /etc/nginx/sites-enabled/default
```

---

# 6.2 Create a new Nginx configuration file

**Create a new Nginx configuration file for the reverse proxy:**

```bash
sudo nano /etc/nginx/sites-available/reverse-proxy.conf
```
**Add the following server block to the file:**

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

# 6.3 Enable the new Nginx configuration

**Create a symbolic link to enable the new configuration:**

```bash
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
```
**Test the Nginx configuration for syntax errors:**

```bash
sudo nginx -t
```

---

# 6.4 Restart Nginx and test

**Restart Nginx to apply the changes:**

```bash
sudo systemctl restart nginx
```

**Open a web browser and test the following urls:**

```
http://<public-ip-of-vm1>/api/hello
http://<public-ip-of-vm1>/api/books
```

---

# 7 Adding firewall rules

**By default let's deny all incoming connections and allow all outgoing connections:**

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

**Allow SSH and HTTP (for Nginx) connections:**

```bash
sudo ufw allow ssh/tcp
sudo ufw allow http/tcp
```
**Enable the firewall:**

```bash
sudo ufw enable
```

---

# 7.1 Checking the firewall status

**Check the status of the firewall:**

```bash
sudo ufw status verbose
```

---

# 7.2 Deleting firewall rules (if needed)

**To delete a rule, first list the numbered rules:**

```bash
sudo ufw status numbered
```
**Delete a rule by its number (e.g., to delete rule 2):**

```bash
sudo ufw delete 2
```

---

# Reflection questions
- Why do we use private IP addresses for communication between VMs?
- What are the benefits of using a reverse proxy like Nginx?
- Why use `127.0.0.1` for the docker containers instead of the public IP?
- Why don't we set firewall rules for the database server?