#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"

mkdir -p "$DATA_DIR/n8n_data"
mkdir -p "$DATA_DIR/pgdata"

chown -R 1000:1000 "$DATA_DIR/n8n_data"
chown -R 999:999 "$DATA_DIR/pgdata"

chmod -R 755 "$DATA_DIR/n8n_data"
chmod -R 700 "$DATA_DIR/pgdata"

echo "✅ Permissions set:"
echo "  - n8n_data → UID 1000"
echo "  - pgdata   → UID 999"
