# Setup Guide: OmniCheck Platform

This guide describes how to set up the development environment on Fedora Linux.

---

# 1. Prerequisites

Install the required tooling before starting.

### Java (Mandrel)

Install **Mandrel 25.0.2** via SDKMAN:

```bash
sdk install java 25.0.2.r25-mandrel
```

Verify installation:

```bash
java -version
```

---

### Container Runtime

Install Podman and the Docker-compatible compose plugin.

Required packages:

* podman
* podman-compose **or** podman-docker

Example (Fedora):

```bash
sudo dnf install podman podman-compose
```

---

### Node.js

Angular 21 requires **Node.js 22.x or newer**.

Install via your preferred method (NodeSource, fnm, nvm, etc.).

Verify:

```bash
node -v
```

---

# 2. Environment Variables

Project credentials are stored in a `.env` file in the project root.

This file is **never committed to Git**.

Create it from the example file:

```bash
cp .env.example .env
```

Then edit it and provide your local values.

Example variables:

```
POSTGRES_USER=omnicheck
POSTGRES_PASSWORD=secret
POSTGRES_DB=omnicheck_dev
POSTGRES_PORT=5432
```

---

# 3. Start Development Infrastructure

Start the PostgreSQL development container using Podman.

The `.env` file must be explicitly provided to Compose:

```bash
podman compose \
  --env-file .env \
  -f infrastructure/compose.dev.yml \
  up -d
```

Verify the container is running:

```bash
podman ps
```

You should see:

```
omnicheck-postgres-dev
```

---

# 4. Application Start

Open separate terminals for backend and frontend.

---

## Backend

```bash
cd backend
./mvnw spring-boot:run
```

The backend will connect to the PostgreSQL container and start the API server.

---

## Frontend

```bash
cd frontend
npm install
ng serve
```

Angular will start the development server.

---

# 5. Database Migrations

Database migrations are handled automatically by **Flyway** via **Spring Boot**.

Migration scripts are located in:

```
backend/src/main/resources/db/migration
```

Example:

```
V1__init.sql
V2__add_users.sql
```

Flyway runs automatically **when the backend starts**.

Startup flow:

```
PostgreSQL container starts
↓
Spring Boot application starts
↓
Flyway checks migration history
↓
New migrations are applied
```

Migration status is stored in the table:

```
flyway_schema_history
```

---

# 6. Native Build

To compile the backend into a native executable using Mandrel:

```bash
cd backend
./mvnw native:compile -Pnative
```

The resulting binary will be located in:

```
backend/target/
```

---

# 7. Database Check

To inspect the running database:

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

# 8. Stopping the Environment

Stop the development infrastructure:

```bash
podman compose \
  -f infrastructure/compose.dev.yml \
  down
```

To also remove database volumes:

```bash
podman compose \
  -f infrastructure/compose.dev.yml \
  down -v
```

⚠️ This deletes all local database data.
