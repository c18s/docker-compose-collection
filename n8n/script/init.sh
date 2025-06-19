#!/bin/bash

# Initialize n8n Docker setup
# This script creates necessary directories and sets proper permissions

set -euo pipefail

# Get the base directory (project root)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🚀 Initializing n8n Docker setup..."

# Create data directories if they don't exist
echo "📁 Creating data directories..."
mkdir -p "$BASE_DIR/data/n8n"
mkdir -p "$BASE_DIR/data/postgresql"
mkdir -p "$BASE_DIR/data/redis"
mkdir -p "$BASE_DIR/data/caddy"

# Create config directories if they don't exist
echo "📁 Creating config directories..."
mkdir -p "$BASE_DIR/config/caddy"

# Set proper permissions for n8n data directory
echo "🔒 Setting permissions for n8n data directory..."
# Use current user's UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Set ownership to current user
chown -R $USER_ID:$GROUP_ID "$BASE_DIR/data/n8n"
chmod -R 755 "$BASE_DIR/data/n8n"

# Copy environment file if it doesn't exist
if [ ! -f "$BASE_DIR/.env" ]; then
    if [ -f "$BASE_DIR/.env.sample" ]; then
        echo "📄 Copying .env.sample to .env..."
        cp "$BASE_DIR/.env.sample" "$BASE_DIR/.env"
        echo "⚠️  Please edit .env file with your configuration!"
    else
        echo "⚠️  Warning: .env.sample not found. Please create .env file manually."
    fi
else
    echo "✅ .env file already exists"
fi

# Set permissions for other directories
echo "🔒 Setting permissions for other data directories..."
chmod -R 755 "$BASE_DIR/data/postgresql"
chmod -R 755 "$BASE_DIR/data/redis"
chmod -R 755 "$BASE_DIR/data/caddy"

echo "✅ Initialization completed!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Run 'make up' to start the services"
