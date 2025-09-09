# GitHub actions: Hash pinning

## Goal
The goal of this exercise is to create a GitHub Action that builds a Maven project, runs tests, and uses hash pinning for the actions used in the workflow.

## What is Hash Pinning?
Hash pinning is a security practice that involves specifying a specific commit hash for an action in your workflow file. This ensures that you are using a known and trusted version of the action, rather than relying on a potentially mutable tag like `@v5`. This helps to prevent supply chain attacks where an attacker could compromise an action and introduce malicious code.

## Semantic Versioning (SemVer)
Semantic Versioning ([SemVer](https://semver.org/)) is a versioning scheme that uses a three-part version number: `MAJOR.MINOR.PATCH`. 
- Increment the `MAJOR` version when you make incompatible API changes.
- Increment the `MINOR` version when you add functionality in a backwards-compatible manner.
- Increment the `PATCH` version when you make backwards-compatible bug fixes.
Using SemVer tags like `@v5` allows you to automatically receive updates that are backwards-compatible.

## SemVer Tags vs. Commit Hashes
Using semantic versioning (SemVer) tags like `@v5` is convenient because it allows you to easily track and manage updates to your actions. However, it also comes with risks, as you may inadvertently use a version of the action that has been compromised. By using a specific commit hash, you can ensure that you are using a known and trusted version of the action.

## Step 1: Find the Commit Hashes
Go to the GitHub repository of the action you are using. For example, for `actions/checkout`, go to [actions/checkout](https://github.com/actions/checkout).

Find the commit you want to use and copy its hash (for this exercise we will use the latest commit hash). On Sep 9th, 2025, the latest commit hash for `v5` for `actions/checkout` is `08c6903cd8c0fde910a37f88322edcfb5dd907a8`. We will use this hash in our workflow file.

## Step 2: Update the Action

Inside the `.github/workflows` directory, open the `java-test.yml` file and update its content to use commit hashes for the actions. Replace the versions with the specific commit hashes you found in Step 1. The updated content should look like this:

```yaml
uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
```

## Step 3: Repeat for Other Actions
Repeat the process for any other actions you are using in your workflow. For example, for `actions/setup-java`, you would find the commit hash for the version you want to use and update the workflow file accordingly.

## Step 4: Commit and Push

Once you have updated all the actions in your workflow file to use commit hashes, commit your changes and push them to your GitHub repository.
You can do this using the following commands:
```bash
git add .github/workflows/java-test.yml
git commit -m "Use hash pinning for GitHub Actions"
git push
```
## Step 5: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "Java test" action. Click on it to see the details.
4. Verify that the action ran successfully and that the tests passed.
5. Check the logs to ensure that the actions were executed using the specified commit hashes.