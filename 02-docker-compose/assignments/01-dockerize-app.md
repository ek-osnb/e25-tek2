# Assignment: Dockerize a Spring Boot Application

In this assignment, you will containerize a Spring Boot application and a MySQL database so the entire stack can be started and managed with Docker Compose.

You can choose to dockerize either the library project or the Spring Boot application, that you worked on in the previous PROG2 exercises.

## Requirements
- Both the Spring Boot application and the MySQL database must be defined and started using a single docker-compose.yml file.
- No sensitive information (e.g., passwords, usernames, database URLs) may be hardcoded inside the Compose file.
    - Use a `.env` file.
    - Ensure your `.env` file is ignored by Git by adding it to `.gitignore`.
- The application must successfully connect to the MySQL database when both are started with Compose.
- Data in the database should persist across container restarts (use volumes).
- The application should be reachable on http://localhost:8080.

## Handin
- There is no handin.
- Treat this as a learning exercise, as it is meant for your own understanding and practice.