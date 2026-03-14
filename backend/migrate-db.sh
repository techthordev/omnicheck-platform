#!/usr/bin/env bash

set -euo pipefail

# Move to project root (one level up)
cd "$(dirname "$0")/.." || exit 1

# Load environment variables
if [ -f .env ]; then
    source .env
elif [ -f load-env.sh ]; then
    source load-env.sh
else
    echo "Error: No .env or load-env.sh found in root"
    exit 1
fi

# Return to backend directory
cd - >/dev/null || exit 1

# Check required variables
: "${SPRING_DATASOURCE_URL:?}"
: "${SPRING_DATASOURCE_USERNAME:?}"
: "${SPRING_DATASOURCE_PASSWORD:?}"

echo "Running Flyway migrate..."

./mvnw flyway:migrate \
    -Dflyway.url="${SPRING_DATASOURCE_URL}" \
    -Dflyway.user="${SPRING_DATASOURCE_USERNAME}" \
    -Dflyway.password="${SPRING_DATASOURCE_PASSWORD}" \
    -Dflyway.locations="classpath:db/migration"

echo "Migration completed."