# Setup Guide: OmniCheck Platform

This guide describes how to set up the development environment on Fedora Linux.

---

# 1. Prerequisites

Install the required tooling before starting.

## Java (Mandrel)

Install Mandrel via SDKMAN:

```bash
sdk install java 25.0.2.r25-mandrel
```

Verify installation:

```bash
java -version
```

---

## Container Runtime

Install Podman and the compose plugin.

Example for Fedora:

```bash
sudo dnf install podman podman-compose
```

Verify installation:

```bash
podman --version
```

---

## Node.js

Angular 21 requires **Node.js 22 or newer**.

Verify:

```bash
node -v
```

---

## direnv (Environment Loader)

Install direnv:

```bash
sudo dnf install direnv
```

Enable direnv in your shell.

Add to `~/.zshrc`:

```bash
eval "$(direnv hook zsh)"
```

Reload your shell:

```bash
exec zsh
```

---

# 2. Environment Variables

All credentials are stored in a `.env` file in the project root.

The `.env` file **must never be committed to Git**.

Create it from the example:

```bash
cp .env.example .env
```

Example `.env`:

```
POSTGRES_DB=omnicheck_dev
POSTGRES_USER=omnicheck
POSTGRES_PASSWORD=omnicheck_secret
POSTGRES_PORT=5432

SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/omnicheck_dev
SPRING_DATASOURCE_USERNAME=omnicheck
SPRING_DATASOURCE_PASSWORD=omnicheck_secret
```

---

## Enable direnv for the Project

Create `.envrc` in the project root:

```bash
echo "dotenv" > .envrc
```

Allow direnv to load the environment:

```bash
direnv allow
```

From now on, every time you enter the project directory the variables from `.env` will automatically be loaded.

Verify:

```bash
echo $SPRING_DATASOURCE_URL
```

Expected output:

```
jdbc:postgresql://localhost:5432/omnicheck_dev
```

---

# 3. Start Development Infrastructure

Start the PostgreSQL container:

```bash
podman compose \
  --env-file .env \
  -f infrastructure/compose.dev.yml \
  up -d
```

Verify:

```bash
podman ps
```

You should see the container:

```
omnicheck-postgres-dev
```

---

# 4. Application Start

Use separate terminals for backend and frontend.

---

## Backend

```bash
cd backend
./mvnw spring-boot:run
```

The backend will start on:

```
http://localhost:8080
```

During startup:

* Spring Boot initializes the application
* Flyway runs database migrations
* Hibernate configures the ORM layer

---

## Frontend

```bash
cd frontend
npm install
ng serve
```

The Angular development server starts on:

```
http://localhost:4200
```

---

# 5. Database Migrations

Database migrations are handled automatically by Flyway.

Migration files are located in:

```
backend/src/main/resources/db/migration
```

Example:

```
V1__init.sql
V2__create_tables.sql
```

Flyway runs migrations automatically when the backend starts.

Migration history is stored in the table:

```
flyway_schema_history
```

---

# 6. Database Access

Open a PostgreSQL shell inside the container:

```bash
podman exec -it omnicheck-postgres-dev \
psql -U omnicheck -d omnicheck_dev
```

List tables:

```sql
\dt
```

Check migration history:

```sql
SELECT * FROM flyway_schema_history;
```

---

# 7. Native Build

To build a native executable using Mandrel:

```bash
cd backend
./mvnw native:compile -Pnative
```

The binary will be generated in:

```
backend/target/
```

---

# 8. Stop the Development Environment

Stop containers:

```bash
podman compose \
-f infrastructure/compose.dev.yml \
down
```

Remove containers and volumes:

```bash
podman compose \
-f infrastructure/compose.dev.yml \
down -v
```

⚠️ This deletes the local database data.

---

# 9. Project Structure

```
backend/        Spring Boot backend
frontend/       Angular frontend
db/             database documentation / optional scripts
docs/           project documentation
infrastructure/ container and deployment configuration
```
