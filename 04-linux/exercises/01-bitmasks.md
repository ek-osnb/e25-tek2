# Exercise: File Permission Bitmasks in Java

In this exercise, you will write a simple Java program that takes bitmasks as input (representing file permissions, e.g., `110` for `rw-`), and prints out the permissions in the style of `rwx` (e.g., `rw-`, `r--`, etc.).

You will use bitwise operators and binary literals in Java.

**Note:** The purpose of this exercise is purely educational. It is designed to help you:
- Learn how bitwise operations work in Java
- Understand the concept of bitmasks (as used in Linux file permissions)
- Practice basic linux commands and shell scripting, including how to add your own commands to the PATH.


## Step 0: Setup
1. Install openJDK-21 via apt (if not already installed):
    ```bash
    sudo apt update
    sudo apt install openjdk-21-jdk
    ```

2. Verify the installation:
    ```bash
    java -version
    ```
    You should see output indicating that Java 21 is installed.

3. Navigate to your home directory (`~`) and create a new directory for this exercise:
    ```bash
    cd ~
    mkdir filepermissions
    cd filepermissions
    ```
4. Create a new file named `FilePermissions.java` in this directory.

5. Use (`nano`or `vim`) to open the file and start editing.

## Step 1: Create a Java Program

1. Create a new file called `FilePermissions.java`.
2. In your program, define three variables for the permission bits using binary literals:
   - `int READ = 0b100;`
   - `int WRITE = 0b010;`
   - `int EXECUTE = 0b001;`

3. The program should take the 3-digit binary string (like `100`, `110`, `111`, etc.) as a command-line argument, e.g.:
   ```
   java FilePermissions 101
   ```
    **Hint:** You can access command-line arguments in Java using the `args` array in the `main` method.
4. Convert the argument to an integer using `Integer.parseInt(args[0], 2)`. The second argument `2` specifies that the input is in base 2 (binary).
5. Use bitwise AND (`&`) to check if each permission is set, and print the result as a string like `rwx`, `rw-`, etc.
6. Additionally, print the decimal equivalent of the binary input.

**Example usages and outputs:**

```
$ java FilePermissions 101
Permissions: r-x
Number: 5

$ java FilePermissions 110
Permissions: rw-
Number: 6

$ java FilePermissions 000
Permissions: ---
Number: 0
```

## Step 2: Test the program

1. Try running your program with different 3-digit binary arguments (like `100`, `111`, `010`) and check if it prints the correct permissions and number.
2. Make sure your output matches the style in the example above.


## Step 3: Making it an executable linux command
1. Compile your Java program:
   ```bash
   javac FilePermissions.java
   ```
2. Create a shell script named `filepermissions` to run your Java program easily:
   ```bash
   #!/bin/bash
   java -cp /path/to/where/you/compiled FilePermissions "$1"
   ```
   Replace `/path/to/where/you/compiled` with the directory where `FilePermissions.class` is located. This makes the script work from any directory.
3. Make the script executable using `chmod`.
4. Move the script to a directory in your PATH (e.g., `/usr/local/bin`) - this is usually where we put user defined commands.
5. Now you can run `filepermissions 101` from anywhere.

---

**Bonus:**

- Accept three 3-digit binary numbers as input (for user, group, and others) and print the full permission string (e.g., `rw-r--r--`).
- Example usage:
   ```
   java FilePermissions 110 100 101
   Permissions: rw-r--r-x
   Number: 645
   ```
