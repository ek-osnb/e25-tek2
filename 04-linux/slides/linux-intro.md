---
marp: true
theme: default
paginate: true
---

# Introduction to Linux

---

## What is Linux?
- Open-source operating system kernel
- Powers servers, desktops, mobile devices, and embedded systems
- Many distributions (Ubuntu, Fedora, Debian, etc.)

**We will use Ubuntu in this course.**

---

## What is a Shell?
- Command-line interface to interact with the OS
- Examples: bash, zsh, sh
- Allows scripting and automation

---


## How to install software on Ubuntu?
- Stands for **Advanced Package Tool**
- Used to install, update, and remove software on Debian-based systems (like Ubuntu)
- Handles dependencies automatically

**Common commands:**
- `sudo apt update` – Update package lists
- `sudo apt upgrade` – Upgrade installed packages
- `sudo apt install <package>` – Install a package
- `sudo apt remove <package>` – Remove a package
- `sudo apt search <term>` – Search for packages

---

## Essential Folders in /
- `/bin` – Essential user binaries
- `/etc` – Configuration files
- `/home` – User home directories
- `/var` – Variable data (logs, etc.)
- `/tmp` – Temporary files
- `/usr` – User programs and data
- `/root` – Root user home
- `/dev` – Device files

---

## Navigation
- `pwd` – Print working directory
- `ls` – List files and folders
- `cd` – Change directory
- `tree` – Visualize directory structure

---

## Changing, Moving, and Showing Files
- `cp` – Copy files
- `mv` – Move/rename files
- `rm` – Remove files
- `cat` – Show file contents
- `less`/`more` – View file contents page by page
- `touch` – Create empty files

---

## File Permissions
- `ls -l` – Show permissions
- Permissions: read (r), write (w), execute (x)
- User, group, others
- `chmod` – Change permissions
- `chown` – Change owner

---

## Bitmasks for Permissions
- Permissions as numbers: r=4, w=2, x=1
- Example: 755 = rwxr-xr-x
- `chmod 755 file`

---

## Pipes and Redirects
- `|` – Pipe output to another command
- `>` – Redirect output to file (overwrite)
- `>>` – Redirect output to file (append)
- Example: `ls | grep txt > files.txt`

---

## Environment Variables
- Store configuration and settings
- `echo $HOME`
- `export VAR=value`
- Used in scripts and by programs

---

## Start of Bash Scripting
- Script file: `myscript.sh`
- Shebang: `#!/bin/bash`
- Make executable: `chmod +x myscript.sh`
- Run: `./myscript.sh`

---

## .bashrc
- User shell configuration file
- Located in home directory
- Customize prompt, aliases, environment variables
- Run `source ~/.bashrc` to reload

---

## Aliases
- Shortcut for commands
- Example: `alias ll='ls -l'`
- Add to `.bashrc` for persistence

---

## Creating Users and Groups
- `sudo adduser username` – Add user
- `sudo usermod -aG group username` – Add user to group
- `groups username` – Show user groups

---

## SSH and authorized_keys
- Secure remote access
- Public key authentication
- `~/.ssh/authorized_keys` stores allowed public keys

---

# Questions?
