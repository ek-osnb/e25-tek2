# GitHub action: Caching dependencies

## Goal
The goal of this exercise is to create a GitHub Action that builds a Maven project, runs tests, and caches the Maven dependencies to speed up subsequent builds.

## Step 1: Setup
Use the same project from the previous exercise.

## Step 2: Update the Action

Open the `java-test.yml` file located in the `.github/workflows` directory and update its content to include caching for Maven dependencies. Replace the existing content with the following:

```yaml
name: Java test with caching
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

      - name: Cache Maven packages
        uses: actions/cache@v4
        with:
          path: ~/.m2/repository
          key: maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: maven-${{ runner.os }}-
      
      - name: Run tests
        run: mvn test
```

We have added a caching step to speed up the build process by reusing the downloaded Maven dependencies. This will significantly reduce the build time for subsequent runs.

A cache-key is created based on the hash of the `pom.xml` file. If the `pom.xml` file changes, a new cache will be created. The `restore-keys` option allows the action to fall back to a more general cache if an exact match is not found.

When the action runs, it will first check if there is a cache available for the current state of the `pom.xml` file. If a cache is found, it will restore the cached dependencies to the `~/.m2/repository` directory before running the Maven tests.

## Step 3: Commit and Push
For the action to take effect, you need to commit and push the changes to your repository.
You can do this using the following commands:
```bash
git add .
git commit -m "Add caching to Maven build GitHub Action"
git push
```

## Step 4: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "Java test with caching" action. Click on it to see the details.
4. Click on the job to see the logs. You should see that the cache is being restored and the tests are running.
5. To see the caching in action, make a small change to the `pom.xml` file (like updating the version of a dependency), commit and push the change, and observe the action run again. The first run after the change will take longer as it rebuilds the cache, but subsequent runs should be faster.