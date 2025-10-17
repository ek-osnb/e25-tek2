# VM1 to VM2 Communication over SSH

In this exercise, we will set up secure communication between two virtual machines (VMs) using SSH keys. We will create a new user on VM2, generate SSH keys on VM1, and configure VM2 to accept connections from VM1 without a password.

The idea is to only allow VM1 to connect to VM2 using SSH keys, and disallow any all other ips from connecting to VM2 via SSH.

## Prerequisites
- Two virtual machines (VM1 and VM2) running a Linux distribution (e.g., Ubuntu).

## Tasks
- Create a new user on `vm2` called `vm1-user` and add it to the `sudo` group.
- Generate an SSH key pair on `vm1` without a passphrase for the `appuser` on `vm1`.
- Copy the public key from `vm1` to `vm2` and add it to the `vm1-user`'s `~/.ssh/authorized_keys` file.
- Test the SSH connection from `vm1` to `vm2` using the new user and SSH keys.
- Set firewall rules (using `ufw`) on `vm2` to only allow SSH connections from `vm1`'s **private IP address**.
    - **Note:** This means that you can't connect to `vm2` from your local machine anymore, only from `vm1`.
- Verify that the firewall rules are working by attempting to SSH into `vm2` from your local machine (it should fail) and from `vm1` (it should succeed).

