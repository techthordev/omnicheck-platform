# Project Structure: OmniCheck Platform

This document describes the internal organization and architectural decisions of the platform.

## Architecture
The platform is built as a decoupled Full-Stack application, optimized for cloud-native deployment.

### 1. Backend (`/backend`)
- **Framework:** Spring Boot 4.0+.
- **Language:** Java 25 (utilizing Virtual Threads for high-concurrency I/O).
- **Style:** RESTful API.
- **Persistence:** Spring Data JPA with Hibernate.
- **Build Tool:** Maven (mvnw).
- **Specialty:** GraalVM/Mandrel support for Native Image compilation.

### 2. Frontend (`/frontend`)
- **Framework:** Angular 21.
- **Approach:** Signals-first for reactive state management.
- **Components:** Standalone components (no NgModules).
- **Styling:** SCSS with a focus on responsive IT-Support dashboards.

### 3. Infrastructure (`/infrastructure`)
- **Container Engine:** Podman (Native on Fedora).
- **Orchestration:** `podman compose`.
- **Environment Separation:** - `compose.dev.yml`: Focused on productivity (PostgreSQL container, live-reload).
  - `compose.prod.yml`: Focused on performance (Native Image, Nginx).

### 4. Database & Migration (`/db/migration`)
- **Engine:** PostgreSQL 18.
- **Versioning:** Flyway handles all schema changes via SQL files.
- **Storage:** Managed via Podman volumes for persistence.

### 5. Documentation (`/docs`)
- Technical guides, CLI references, and architecture decision logs (ADR).