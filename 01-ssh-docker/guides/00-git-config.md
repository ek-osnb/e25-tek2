# Git init


## Prerequisites
Make sure that you have Git installed on your machine, if not you can download it from here:
- [Git Downloads](https://git-scm.com/downloads)
- When installing Git, use the preselected options.

## Checking Git Configuration
Check if your Git configuration is set up correctly. First run the following commands (**Windows**: Git Bash, **MacOS/Linux**: Terminal):

```bash
git config user.name
git config user.email
```

If the output is empty or if the email does not match your GitHub account, you need to configure your Git user information.

**If the email match your email used in GitHub, you can skip the next step.**

### Configuring Git

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
- Replace `Your Name` with your GitHub username.
- Replace `you@example.com` with your email address associated with your GitHub account.

Now your Git configuration is set up correctly.
