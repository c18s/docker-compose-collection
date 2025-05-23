#!/bin/bash
set -e

# Check if running as root or with sudo, if not auto-run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script requires root privileges. Running with sudo..."
   exec sudo "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"

echo "Data directory: $DATA_DIR"

mkdir -p "$DATA_DIR/n8n_data"
mkdir -p "$DATA_DIR/pgdata"

chown -R 1000:1000 "$DATA_DIR/n8n_data"
chown -R 999:999 "$DATA_DIR/pgdata"

chmod -R 755 "$DATA_DIR/n8n_data"
chmod -R 700 "$DATA_DIR/pgdata"

echo "✅ Permissions set:"
echo "  - n8n_data → UID 1000"
echo "  - pgdata   → UID 999"
