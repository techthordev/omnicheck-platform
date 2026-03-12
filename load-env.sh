#!/usr/bin/env bash
# ============================================================
# load-env.sh – Exports .env variables into the current shell
# Usage (IMPORTANT: must be called with "source"):
#   source ./load-env.sh
# ============================================================

ENV_FILE="$(dirname "$0")/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found!"
  return 1
fi

export $(grep -v '^#' "$ENV_FILE" | xargs)
echo "✅ Environment variables loaded."