#!/usr/bin/env bash
set -euo pipefail

if ! pg_isready -q 2>/dev/null; then
  sudo service postgresql start
  until pg_isready -q; do sleep 1; done
fi

if ! sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'supportflow'" | grep -q 1; then
  sudo -u postgres createdb supportflow
fi

export DB_URL="${DB_URL:-jdbc:postgresql://localhost:5432/supportflow}"
export DB_USERNAME="${DB_USERNAME:-postgres}"
export DB_PASSWORD="${DB_PASSWORD:-postgres}"
export SERVER_PORT="${SERVER_PORT:-8080}"

cd /workspace
exec ./mvnw spring-boot:run
