# Guided Linux Terminal Exercises

These exercises are designed to help you practice the basics of Linux terminal usage. Follow each step and try the commands on your own system.

---

## 1. Navigating Directories

- Use `pwd` to print your current directory.
- Use `ls` to list files and folders.
- Use `cd` to move into your home directory, then into `/tmp`, then back to your home directory.

## 2. Copying, Moving, and Deleting Files

- Create a file called `testfile.txt` using `touch`.
- Copy `testfile.txt` to `copyfile.txt` using `cp`.
- Move `copyfile.txt` to a new name `movedfile.txt` using `mv`.
- Delete `movedfile.txt` using `rm`.

## 3. File Permissions

- Use `ls -l` to view file permissions.
- Change the permissions of `testfile.txt` to make it executable using `chmod +x testfile.txt`.
- Change the owner of the file (if you have permission) using `sudo chown $USER testfile.txt`.

## 4. Piping and Redirection

- Use `echo "Hello World" > hello.txt` to create a file.
- Use `cat hello.txt | grep Hello` to search for the word "Hello".
- Use `ls | wc -l` to count the number of files in the current directory.

## 5. Editing Files

- Open `hello.txt` with `nano` and add a new line.
- Open `hello.txt` with `vim` and add another line.

## 6. Environment Variables

- Print your PATH variable with `echo $PATH`.
- Set a new environment variable: `export MYVAR=linux`.
- Print it: `echo $MYVAR`.

## 7. Bash Scripting

- Create a file called `myscript.sh`.
- Add the following lines:

  ```bash
  #!/bin/bash
  echo "This is my first script!"
  ```
- Make it executable: `chmod +x myscript.sh`.
- Run it: `./myscript.sh`.

## 8. .bashrc Customization

- Open your `.bashrc` file with `nano ~/.bashrc`.
- Add a line: `alias ll='ls -l'`.
- Save and close, then run `source ~/.bashrc`.
- Try your new alias: `ll`.

## 9. Downloading and Archiving

- Use `wget https://example.com` to download a file.
- Use `tar -cvf archive.tar *.txt` to create a tar archive of all `.txt` files.
- Use `gzip archive.tar` to compress the archive.
- Use `ls` to see your new `.tar.gz` file.

---

Try each exercise and ask questions if you get stuck!