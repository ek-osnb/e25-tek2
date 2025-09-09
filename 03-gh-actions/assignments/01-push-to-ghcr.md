# Assignment: Push to GitHub Container Registry

## Goal
Create a GitHub Action that builds a Docker image and pushes it to GitHub Container Registry (GHCR) on every push to the `main` branch.

## Requirements
- Use an existing Spring Boot application (not the one used in previous exercises).
- A database connection with profiles (one for H2 and one for MySQL).
- A Dockerfile to build the application image.
- A `compose.yml` file to run the application locally.
- The application should be able to run with `docker compose up -d`.
- The GitHub Action should build the Docker image and push it to GHCR.
- There should be two workflows:
    - One for running tests
    - One for building and pushing the Docker image to GHCR