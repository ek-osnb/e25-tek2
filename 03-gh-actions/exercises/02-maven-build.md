# GitHub action: Maven build

## Goal
The goal of this exercise is to create a GitHub Action that builds a Maven project and runs tests.

## Step 1: Setup

Use the same project from the previous exercise.

## Step 2: Create the Action
Inside the `.github/workflows` directory, create a new file named `java-test.yml`.

Open the `java-test.yml` file and add the following content:
```yaml
name: Java test

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Set up JDK
        uses: actions/setup-java@v5
        with:
            java-version: '21'
            distribution: 'temurin'

      - name: Run tests
        run: mvn test
```
The `on` section specifies that the action will run on pushes and pull requests to the `main` branch.

The `workflow_dispatch` event allows you to manually trigger the workflow from the GitHub Actions tab in your GitHub repository.

The `steps` section defines the individual steps of the job:
1. The first step checks out the repository code.
2. The second step sets up the Java Development Kit (JDK) using the `actions/setup-java` action.
3. The third step runs the Maven command to execute the tests.

## Step 3: Commit and Push
For the action to take effect, you need to commit and push the changes to your repository. You can do this using the following commands:
```bash
git add .
git commit -m "Add Maven build GitHub Action"
git push
```

## Step 4: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "Java test" action. Click on it to see the details.
4. Click on the job to see the logs. You should see the output of the Maven build and test execution. If the tests pass, you will see a success message; if any tests fail, you will see the failure details in the logs.