# Updating firewall rules

In this exercise, we will update the firewall rules on `vm1` to allow incoming HTTP traffic on port 80, so that we can access the Nginx reverse proxy from outside the VM. On `vm2`, we will only allow the MySQL port 3307 to be accessible from `vm1`. This will enhance the security of our setup by restricting access to the database server.

## Step 1: Setting up UFW on `vm1``

For this we will use UFW (Uncomplicated Firewall), which is a user-friendly frontend for managing firewall rules in Linux.

SSH into `vm1`:

```bash
ssh appuser@<VM1_IP_ADDRESS>
```
First, check the status of UFW:

```bash
sudo ufw status
```
It should show that UFW is inactive. 

Let's add rules to allow incoming traffic on port 80 (HTTP) and port 22 (SSH):

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 80/tcp
sudo ufw allow 22/tcp
```

**If we didn't allow port 22, we would lock ourselves out of the VM!**

Now, enable UFW:

```bash
sudo ufw enable
```
Confirm the changes by checking the status again:

```bash
sudo ufw status
```

You should see that ports 22 and 80 are allowed.

### Test access to the reverse proxy from outside

Now, from your local machine, try to access the Nginx reverse proxy running on `vm1` using `curl` or a web browser:

```bash
curl http://<VM1_IP_ADDRESS>/api/hello
curl http://<VM1_IP_ADDRESS>/api/books
```

You should see the responses from the backend application, confirming that the reverse proxy is accessible from outside `vm1`.

Try accessing the backend service directly (it should be blocked):

```bash
curl http://<VM1_IP_ADDRESS>:8090/api/hello
```
You should not receive a response, indicating that direct access to the backend service is blocked.

## Step 2: Setting up UFW on `vm2`

On the database server `vm2`, we will configure UFW to only allow incoming MySQL traffic (port 3307) from `vm1`, and SSH traffic (port 22) from anywhere (usually we should restrict this to specific IPs).

SSH into `vm2`:

```bash
ssh appuser@<VM2_IP_ADDRESS>
```

First, check the status of UFW:

```bash
sudo ufw status
```

It should show that UFW is inactive.

Let's add rules to allow incoming traffic on port 22 (SSH) from anywhere:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
```
The `proto` option specifies the protocol (TCP in this case - we will discuss tcp later in the course).

Now, enable UFW:

```bash
sudo ufw enable
```

Confirm the changes by checking the status again:

```bash
sudo ufw status
```
**You should see that port `22` is allowed from anywhere. But nowhere is the MySQL port allowed. But `vm1` is still able to access it, since docker bypasses UFW rules by default - this can be changed but this is out of scope for this exercise.**

### Caveats with UFW and Docker

When using UFW on the host machine, Docker can bypass UFW rules. This means that even if UFW is configured to block certain ports, Docker containers may still be able to accept traffic on those ports. 

Since we did portmapping on the private ip address of `vm2`, we still only restrict access to the MySQL server to all VMs in the same VPC as `vm1` and `vm2`.

### Test access to the MySQL server from your local machine

We can test that the backend service can fetch data from the database server, by runnning:

```bash
curl http://<VM1_IP_ADDRESS>/api/books
```
You should see the list of books returned by the application, indicating that it can successfully connect to the MySQL server on `vm2`.

Try accessing the MySQL server directly from your local machine (it should be blocked):

```bash
mysql -h <VM2_IP_ADDRESS> -u <YOUR_APP_USER> -p
```
Replace `<VM2_IP_ADDRESS>` and `<YOUR_APP_USER>` with the appropriate values. You should not be able to connect, indicating that direct access to the MySQL server is blocked.


## Step 3 (optional): Firewall settings on DigitalOcean

While we have configured UFW on both VMs, DigitalOcean also provides its own firewall settings that can be managed through the DigitalOcean Control Panel. This firewall sits at the network edge and can provide an additional layer of security.

On DigitalOcean's firewall, we want the following rules:
- `vm1`:
    - Allow incoming traffic on port 22 (SSH) from anywhere (or restrict to your Public IP Address for better security)
    - Allow incoming traffic on port 80 (HTTP) from anywhere
- `vm2`:
    - Allow incoming traffic on port 22 (SSH) from anywhere (or restrict to your Public IP Address for better security)
    - Allow incoming traffic on port 3307 (MySQL) from `vm1`'s private IP address

Make sure to review and adjust these settings in the DigitalOcean Control Panel to match the UFW rules we set up on the VMs.