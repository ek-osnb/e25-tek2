# Guided Exercise: Adding Users and SSH Access on a VM

In this exercise, you will create a new user on your VM, add them to a group, and set up SSH access using a public key from GitHub. You will also learn how to clean up users and groups when finished.

> **Note:** You need to run most of these commands as root or with `sudo`.

## Step 0: Prerequisites
1. Ensure you have a VM running with SSH access.

## Step 1: Create a New User and Group

1. Create a new user for your fellow student (replace `studentname` with their username):
	```bash
	sudo useradd -m studentname
	```
2. Create a group for collaboration (e.g., `projectgroup`):
	```bash
	sudo groupadd projectgroup
	sudo usermod -aG projectgroup studentname
	```

## Step 2: Add SSH Key from GitHub

1. On your VM, fetch your fellow student's public key from GitHub (replace `githubusername`):
	```bash
	curl https://github.com/githubusername.keys >> /home/studentname/.ssh/authorized_keys
	sudo chown studentname:studentname /home/studentname/.ssh/authorized_keys
	sudo chmod 600 /home/studentname/.ssh/authorized_keys
	```
	> You may need to create the `.ssh` directory first:
	> ```bash
	> sudo mkdir -p /home/studentname/.ssh
	> sudo chown studentname:studentname /home/studentname/.ssh
	> sudo chmod 700 /home/studentname/.ssh
	> ```

## Step 3: Create a shared directory and a private directory
1. Create a shared directory for the group:
    ```bash
    sudo mkdir /home/shared
    sudo chown root:projectgroup /home/shared
    sudo chmod 770 /home/shared
    ```
2. Create a private directory that is private for the new user:
    ```bash
    sudo mkdir /home/studentname/private
    sudo chown studentname:studentname /home/studentname/private
    sudo chmod 700 /home/studentname/private
    ```

## Step 4: Test SSH Access

1. Ask your fellow student to SSH into your VM:
	```bash
	ssh studentname@<your-vm-ip>
	```
	They should be able to log in without a password if their public key was added correctly.
2. Once logged in, they can check their group membership:
    ```bash
    groups
    ```
    They should see `projectgroup` listed.
3. Check access to the shared directory:
    ```bash
    cd /home/shared
    touch testfile.txt
    ls -l
    ```
    They should be able to create and list files in the shared directory.
4. Check access to the owner's private directory:
    ```bash
    cd /home/studentname/private
    ```
    They should not be able to access this directory.

## Step 5: Clean Up

1. When finished, delete the user and their home directory:
	```bash
	sudo userdel -r studentname
	```
2. Delete the group:
	```bash
	sudo groupdel projectgroup
	```

