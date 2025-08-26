# Create SSH Key

This guide will help you generate a SSH key pair and use it with your GitHub account.

## Step 1: Creating the SSH Key

1. Open your terminal (Windows: Git Bash, macOS/Linux: Terminal).

2. Run the following command to generate a new SSH key pair:
    ```bash
    ssh-keygen -t ed25519
    ```

3. When prompted for a file to save the key, press `Enter` to accept the default location (`~/.ssh/id_ed25519`).

4. Press `Enter` twice to leave the passphrase empty.

5. Your SSH key pair will be created, and placed in the `~/.ssh` directory. The public key ends with `.pub`.


## Step 2: Add the SSH Key to your GitHub Account

1. Copy the contets of your public key to the clipboard:
    ```bash
    cat ~/.ssh/id_ed25519.pub | pbcopy  # macOS
    cat ~/.ssh/id_ed25519.pub | clip    # Windows (Git Bash)
    ```
2. Navigate to this link [GitHub settings](https://github.com/settings/keys).

4. Click on **New SSH key**.

5. Paste your public key into the "Key" field.

6. You can skip the "Title" field or give it a descriptive name.

7. Click **Add SSH key** to save it.

## Step 3: Test the SSH Connection

1. In your terminal, run the following command to test the connection:

    ```bash
    ssh -T git@github.com
    ```

2. If everything is set up correctly, you should see a message like:
    ```
    Hi username! You've successfully authenticated, but GitHub does not provide shell access.
    ```

3. If you see a warning about the authenticity of the host, type `yes` to continue.

<!-- 4. If you encounter any issues, ensure that your SSH agent is running and your key is added:
    ```bash
    eval "$(ssh-agent -s)"  # Start the SSH agent and set the environment variable
    ssh-add ~/.ssh/id_ed25519  # Add your SSH key to the agent
    ``` -->

## Step 4: Cloning a Repository using SSH

Now that you have your SSH key set up, you can clone repositories using SSH:

```bash
git clone git@github.com:username/repo.git
```

- replace the `username` with your GitHub username and `repo.git` with the repository you want to clone.

