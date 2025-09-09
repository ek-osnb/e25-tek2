# GitHub Action: Reusable Workflows

## Goal
Make the java test and docker CI workflows reusable so they can be called from other workflows. See the [GitHub documentation](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows) for more details.

## Step 1: Create reusable workflow files
1. Inside the `.github/workflows` directory, create a new file named `java-test-reusable.yml`.
2. Open the `java-test-reusable.yml` file and add the following content:

```yaml
name: Java test reusable
on:
  workflow_call:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
      - name: Set up JDK
        uses: actions/setup-java@v5
        with:
            java-version: '21'
            distribution: 'temurin'

      - name: Run tests
        run: mvn test
```
The `on: workflow_call` event allows this workflow to be called by other workflows.

For the `docker-ci` workflow, create a new file named `docker-ci-reusable.yml` and add the following content:

```yaml
name: Docker CI reusable
on:
	workflow_call:

jobs:
	build:
		runs-on: ubuntu-latest
		steps:
			- name: Checkout code
				uses: actions/checkout@08c6903cd8c0fde910a37f88322edcfb5dd907a8 # v5.0.0
			- name: Test container
				run: |
					# Run the container in detached mode
					docker compose up -d
					
					# Wait for a few seconds to ensure the container is up and running
					sleep 40

					# Test the application endpoint
					curl -f http://localhost:8080/actuator/health || exit 1

					# Stop and remove the container
					docker compose down
```

## Step 2: Disable previous workflows
Move the existing `java-test.yml` and `docker-ci.yml` files to a new folder named `.github/disabled-workflows`. This ensures that they are not run, as only workflows in the `.github/workflows` folder are executed.


## Step 3: Update existing workflows to call reusable workflows
Now, create a new workflow file named `ci.yml` in the `.github/workflows` directory and add the following content:

```yaml
name: CI

on:
  push:
    branches:
      - main
	pull_request:
		branches:
			- main
	workflow_dispatch:

jobs:
	java-test:
		uses: ./.github/workflows/java-test-reusable.yml

	docker-ci:
		needs: java-test
		uses: ./.github/workflows/docker-ci-reusable.yml
```

This `ci.yml` workflow calls the reusable `java-test-reusable.yml` and `docker-ci-reusable.yml` workflows. The `docker-ci` job depends on the successful completion of the `java-test` job.

## Step 4: Commit and Push
For the changes to take effect, you need to commit and push them to your repository. You can do this using the following commands:
```bash
git add .
git commit -m "Make Java test and Docker CI workflows reusable"
git push
```

## Step 5: Verify the Action
1. Go to your GitHub repository in your web browser.
2. Click on the "Actions" tab.
3. You should see a new workflow run for the "CI" action. Click on it to see the details.
4. Click on the jobs to see the logs. You should see the steps for checking out the code, setting up JDK, running tests, building the Docker image,running the container, and testing the application endpoint.
5. Ensure that both jobs complete successfully.
