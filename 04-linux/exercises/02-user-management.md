# Guided Exercise: User and Group Management in Linux

In this exercise, you will learn how to manage users and groups on a Linux system. You will create and delete users and groups, and practice switching between users.

> **Note:** You need to run most of these commands as root or with `sudo`.

## Step 1: Create a New User

1. Create a new user called `student1`:
	```bash
	sudo useradd -m student1
	sudo passwd student1
	```
	The `-m` flag creates a home directory for the user. Set a password when prompted.

## Step 2: Create a New Group

1. Create a new group called `projectgroup`:
	```bash
	sudo groupadd projectgroup
	```

## Step 3: Add the User to the Group

1. Add `student1` to `projectgroup`:
	```bash
	sudo usermod -aG projectgroup student1
	```
2. Check the groups for `student1`:
	```bash
	groups student1
	```

## Step 4: Switch Between Users

1. Switch to the new user:
	```bash
	su - student1
	```
	To return to your original user, type `exit`.

## Step 5: Delete the User and Group

1. Log out of `student1` if you are still logged in (`exit`).
2. Delete the user and their home directory:
	```bash
	sudo userdel -r student1
	```
3. Delete the group:
	```bash
	sudo groupdel projectgroup
	```

---

**Extra:** Try creating more users and groups, and experiment with adding/removing users from multiple groups.
