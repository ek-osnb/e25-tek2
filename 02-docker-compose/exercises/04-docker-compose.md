# Docker compose

`Docker compose` is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services, networks, and volumes. Then, with a single command, you create and start all the services from your configuration.

Up until now we had to manually create and manage each container individually. With Docker Compose, we can define all of our services in a single file and manage them together.

In this exercise we will create a `docker-compose.yml` file to define a database, and a web application that connects to it.

## YAML syntax
YAML is a human-readable data serialization format. It is commonly used for configuration files and data exchange between languages with different data structures. In a `docker-compose.yml` file, you define your application's services, networks, and volumes using YAML syntax.

YAML uses indentation to represent the structure of the data. Each level of indentation represents a new level in the hierarchy. For example, in the `docker-compose.yml` file, the services are defined at the top level, and each service has its own set of properties indented beneath it.

## Goal:

The goal of this exercise is to create a Docker Compose file that defines a MySQL database service, and using volumes to persist data beyond the container's lifecycle.

## Step 1: Create a docker-compose.yml file
Create a new file named `docker-compose.yml` in the root of your project directory.

```yaml
services:
  db:
    container_name: the_db
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: secret
    ports:
      - "3307:3306"
```

Notice that we map port `3307` on the host to port `3306` on the container. This is because you probably already have MySQL running on your host machine at the default port `3306`. By mapping to `3307`, we avoid port conflicts.

Previously we would have run the following command to start the MySQL container:

```bash
docker run -d --name the_db -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=mydb -e MYSQL_USER=user -e MYSQL_PASSWORD=secret mysql:8.0
```

## Step 2: Starting container using docker compose

To start the container defined in the `docker-compose.yml` file, you can use the following command:
```bash
docker compose up -d
```

This command will start the services (here only the MySQL db) defined in the `docker-compose.yml` file in **detached mode**.

## Step 3: Entering the container

To enter the running container, you can use the following command:

```bash
docker exec -it the_db sh
```

This will give shell inside the `the_db` container, allowing you to interact with the MySQL database directly.

To access the MySQL shell, you can use the following command:

```bash
mysql -u user -p
```

You will be prompted for the password. Enter `secret` to access the MySQL shell.

## Step 4: Basic commands inside MySQL

Try to run the following command (remember in the end`;`):

```sql
SHOW DATABASES;
```
You should see the `mydb` database that we created using the environment variables in the `docker-compose.yml` file.

To use the database, you can run the following command:

```sql
USE mydb;
```

Now you can create tables and insert data into the `mydb` database.

Try to run:

```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);
```

And insert data:

```sql
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
```

Try to view the data:

```sql
SELECT * FROM users;
```

And you should see:

```bash
+----+----------+------------------+
| id | name     | email            |
+----+----------+------------------+
|  1 | John Doe | john@example.com |
+----+----------+------------------+
1 row in set (0.00 sec)
```

Exit the MySQL shell by typing:

```bash
exit
```

And exit the container by typing:

```bash
exit
```

## Step 5: Stopping the container

To stop the containers defined in the `docker-compose.yml` file, you can use the following command:

```bash
docker compose down
```

This command will stop and remove all the services defined in the `docker-compose.yml` file.

## Step 6: Recreating the container

Try to recreate the container using the following command:

```bash
docker compose up -d
```

Open up a shell inside the `the_db` container:

```bash
docker exec -it the_db sh
```

Try to see if the data created earlier is still present:

```bash
mysql -u user -p
```

Enter the password `secret` when prompted.

```sql
select * from mydb.users;
```
You should get the following:
```bash
ERROR 1146 (42S02): Table 'mydb.users' doesn't exist
```

This is because each time you stop the container, the data stored in the container's filesystem is lost. To persist the data, you need to use Docker volumes. Volumes are stored outside the container's filesystem and can be reused even if the container is stopped or recreated.

## Step 7: Using volumes to persist data

Fortunately, adding volume support in the `docker-compose.yml` file is straightforward. Replace the `db` service definition with the following:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: secret
    ports:
      - "3307:3306"
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
    name: the_db_volume # Just for demo purpose
```

`db_data` is a **named volume** that is used to persist the data stored in the MySQL database. In earlier exercises we have used bind mounts, to map a directory on the host to a directory in the container. Named volumes are managed by Docker and are stored in a part of the filesystem which is managed by Docker.

## Step 8: Verifying data persistence

Start the service again using Docker Compose:

```bash
docker compose up -d
```

### Student tasks:
- add some data to the database
- exit the MySQL shell and container shell
- stop the containers using `docker compose down`
- start the containers again using `docker compose up -d`
- enter the MySQL shell and check if the data is still present


## Step 9: Cleaning up
To stop and remove the containers defined in the `docker-compose.yml` file, you can use the following command:

```bash
docker compose down
```

This will not remove the volume created. First check the list of volumes:

```bash
docker volume ls
```

You should see the `the_db_volume` volume listed. To remove the volume, you can use the following command:

```bash
docker volume rm the_db_volume
```

If you want to remove everything in one command, use:
```bash
docker compose down -v
```

