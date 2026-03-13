#!/usr/bin/env bash

SESSION="omnicheck"
PROJECT_ROOT=$(pwd)

# 1. Existenz-Check
tmux has-session -t $SESSION 2>/dev/null
if [ $? == 0 ]; then
    echo "⚠️ Session $SESSION läuft bereits. Verbinde..."
    tmux attach-session -t $SESSION
    exit 0
fi

echo "🚀 Initialisiere OmniCheck (Maven & Podman)..."

# 2. Window 1: Infrastructure
tmux new-session -d -s $SESSION -n "infra" -c "$PROJECT_ROOT"
tmux send-keys -t "$SESSION:1.1" "clear" C-m
# Den spezifischen Container-Namen nutzen (Vorbereitet zum Starten)
tmux send-keys -t "$SESSION:1.1" "podman start omnicheck-postgres-dev" 

# Pane 1.2: DB-Shell daneben
tmux split-window -h -t "$SESSION:1" -c "$PROJECT_ROOT"
tmux send-keys -t "$SESSION:1.2" "clear" C-m
# Nutzt direkt den Standard-User für PostgreSQL
tmux send-keys -t "$SESSION:1.2" "psql -h localhost -U postgres"

# 3. Window 2: Backend (Maven)
tmux new-window -t "$SESSION:2" -n "backend" -c "$PROJECT_ROOT/backend"
tmux send-keys -t "$SESSION:2.1" "clear" C-m
tmux send-keys -t "$SESSION:2.1" "./mvnw spring-boot:run" 

# 4. Window 3: Frontend (Angular 21)
tmux new-window -t "$SESSION:3" -n "frontend" -c "$PROJECT_ROOT/frontend"
tmux send-keys -t "$SESSION:3.1" "clear" C-m
tmux send-keys -t "$SESSION:3.1" "ng serve"

# Fokus auf das Infra-Fenster zum Starten der DB
tmux select-window -t "$SESSION:1"
tmux select-pane -t "$SESSION:1.1"

# Attach
tmux attach-session -t $SESSION