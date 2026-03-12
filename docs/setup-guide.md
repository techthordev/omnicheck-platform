# Setup Guide: OmniCheck Platform

This guide describes how to set up the development environment on Fedora Linux.

## 1. Prerequisites

- **Mandrel 25.0.2**: Install via SDKMAN!

  ```bash
  sdk install java 25.0.2.r25-mandrel
  ```
  
- **Podman**: Ensure `podman` and `podman-compose` (package `podman-compose` or `podman-docker`) are installed.
- **Node.js**: Version 22.x or higher for Angular 21.

## 2. Environment Variables

All credentials are stored in a `.env` file in the project root. It is never committed to Git.

```bash
cp .env.example .env
# Fill in your values
```

Load the variables into your current shell session before starting the backend:

```bash
source ./load-env.sh
```

> ⚠️ Always use `source` — running it directly (`./load-env.sh`) will not export the variables to your current shell.

## 3. Infrastructure Setup

To start the development database:

```bash
podman compose -f infrastructure/compose.dev.yml up -d
```

## 4. Application Start

**Backend:**

```bash
cd backend && ./mvnw spring-boot:run
```

**Frontend:**

```bash
cd frontend && npm install && ng serve
```

## 5. Database Migrations

Flyway runs automatically on backend startup. Migration scripts are located in `db/migration/`.

## 6. Native Build

To compile the backend to a native binary:

```bash
cd backend && ./mvnw native:compile -Pnative
```

## 7. Database Check

```bash
podman exec -it omnicheck-postgres-dev psql -U omnicheck -d omnicheck_dev -c "\dt"
```
