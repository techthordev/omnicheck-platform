# 1. Prerequisites
Install the required tooling before starting.

## Java (Mandrel)
Install Mandrel via SDKMAN (optimized for GraalVM/Native Image):
```bash
sdk install java 25.0.2.r25-mandrel
```

## Container Runtime
Install Podman and the compose plugin (Fedora native):
```bash
sudo dnf install podman podman-compose
```

## Node.js & Angular
Angular 21 requires **Node.js 22+**.
```bash
npm install -g @angular/cli
```

## Terminal Multiplexer
For managing the development environment:
```bash
sudo dnf install tmux
```

---

# 2. Environment & direnv
All credentials are stored in a `.env` file. **Never commit this file.**

1. **Create .env:** `cp .env.example .env`
2. **Setup direnv:**
```bash
sudo dnf install direnv
# Add to ~/.zshrc: eval "$(direnv hook zsh)"
echo "dotenv" > .envrc
direnv allow
```

---

# 3. Development Workflow (The tmux Way)
Instead of opening multiple terminal windows manually, use the provided orchestrator script.

**Start the Environment:**
```bash
chmod +x dev-tmux.sh
./dev-tmux.sh
```

**Layout in tmux:**
* **Window 1 (`infra`):** Manage Podman and Database.
* **Window 2 (`backend`):** Spring Boot 4 / Java 25 (Maven).
* **Window 3 (`frontend`):** Angular 21 (Signals-first).

**Essential tmux Shortcuts:**
* `Ctrl + b` then `1, 2, 3`: Switch Tabs.
* `Ctrl + b` then `d`: Detach (Processes keep running!).
* `Ctrl + b` then `z`: Zoom Pane (Fullscreen for logs).

---

# 4. Component Details

## Infrastructure (Podman)

**Start (dev):**
```bash
podman compose -f compose.dev.yml up -d
```

**Stop and remove everything:**
```bash
podman compose -f compose.dev.yml down --volumes --remove-orphans
podman system prune -af --volumes
```

**Start (prod):**
```bash
podman compose -f compose.prod.yml up -d
```

The `postgres-init/` directory contains SQL scripts that run automatically on first container startup.

## Backend (Spring Boot 4)
* **Start:** `./mvnw spring-boot:run`
* **Stack:** Java 25, Virtual Threads, Flyway Migrations.
* **Config:** `backend/src/main/resources/application.properties`

## Frontend (Angular 21)
* **Start:** `ng serve`
* **Features:** Signals-only, Standalone Components.

---

# 5. Database Access
```bash
psql -h localhost -U postgres -d omnicheck_dev
```

---

# 6. Native Build
To build a native Linux binary with Mandrel:
```bash
cd backend
./mvnw native:compile -Pnative
```
The binary is generated in `backend/target/`.

---

# 7. Project Structure
```
.
├── backend/
│   └── src/main/java/br/com/techthordev/backend/
│       ├── entities/       # JPA entities (class)
│       │   ├── Service.java
│       │   ├── HealthCheck.java
│       │   └── HealthStatus.java
│       └── dto/            # Request/Response DTOs (record)
├── frontend/               # Angular 21+, Signals, Tailwind
├── infrastructure/
│   ├── compose.dev.yml
│   ├── compose.prod.yml
│   └── postgres-init/      # SQL scripts run on first startup
├── dev-tmux.sh             # Main tmux Orchestrator
├── .envrc                  # direnv loader
├── .env                    # Local Secrets (ignored by git)
└── .tmux.conf              # Local tmux configuration
```
