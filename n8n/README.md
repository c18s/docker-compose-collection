# 🚀 n8n Docker Compose Setup

A simple and production-ready setup for n8n with PostgreSQL, Redis, and Caddy reverse proxy.

## 🔧 Installation

1. **Initialize the setup:**

   ```bash
   make init
   ```

   This will:
   - Create necessary directories (`./data/`, `./config/`)
   - Set proper permissions
   - Copy `.env.sample` to `.env` (if not exists)

2. **Edit the configuration:**

   Update the following variables in `.env`:

   ```env
   # Timezone (Required)
   GENERIC_TIMEZONE=Asia/Bangkok

   # Database Configuration
   POSTGRES_USER=n8n_admin
   POSTGRES_PASSWORD=your_secure_password_here
   POSTGRES_DB=n8n

   # Non-root database user (recommended for production)
   POSTGRES_NON_ROOT_USER=n8n_user
   POSTGRES_NON_ROOT_PASSWORD=your_secure_user_password_here

   # n8n Configuration
   ENCRYPTION_KEY=your_32_character_encryption_key_here

   # Optional: n8n Environment Settings
   N8N_HOST=localhost
   N8N_PORT=5678
   N8N_PROTOCOL=http

   # Optional: Webhook Configuration
   # WEBHOOK_URL=https://your-domain.com/
   ```

3. **Start the services:**

   ```bash
   make start
   ```

4. **Access n8n:**
   - Via Caddy: `http://localhost` (or the domain set in `N8N_HOST`)

## 📋 Available Commands

```bash
make help          # Show all available commands with organized sections
make init          # Initialize directories, permissions, and .env file
make start         # Start all services
make stop          # Stop all services
make restart       # Restart all services (stop then start)
make logs          # View logs from all services

# Database Management
make backup        # Backup PostgreSQL database
make restore FILE=backup.sql    # Restore PostgreSQL database
make clean-restore FILE=backup.sql  # Drop and restore PostgreSQL database
make drop-db       # Drop the PostgreSQL database (WARNING: destroys all data)
make create-db     # Create a new PostgreSQL database

# Worker Scaling
make scale WORKERS=n  # Scale n8n-worker instances to 'n' workers
```

## 🐳 Services

- **n8n**: Main application (accessible at `127.0.0.1:5678`)
- **PostgreSQL**: Database (accessible at `127.0.0.1:5432`)
- **Redis**: Queue and cache (accessible at `127.0.0.1:6379`)
- **Caddy**: Reverse proxy (ports 80/443)

## 💾 Data Persistence

All data is stored in the `./data/` directory:

- `./data/n8n/` - n8n workflows and settings
- `./data/postgresql/` - Database files
- `./data/redis/` - Redis data
- `./data/caddy/` - TLS certificates

## 🔒 Security Notes

- n8n is bound to `127.0.0.1:5678` (localhost only).
- PostgreSQL and Redis are also bound to `127.0.0.1` for security.
- External access should go through the Caddy reverse proxy.
- Use strong passwords for database users.
- Generate a random 32-character encryption key.

## 🛠️ Troubleshooting

### Common Issues

1. **Database connection issues:**

   ```bash
   make logs
   # Or
   docker compose logs postgres
   ```

2. **Redis connection issues:**

   ```bash
   docker compose logs redis
   ```

3. **Check service health:**

   ```bash
   docker compose ps
   ```

### Logs Location

- **Application logs**: `make logs`
- **Service-specific logs**: `docker compose logs [service-name]`
- **Data directory**: `./data/`
- **Configuration directory**: `./config/`

## 🌐 Using a Custom Domain

1. **Update `.env`:**

   ```env
   N8N_HOST=n8n.yourdomain.com
   N8N_PROTOCOL=https

   WEBHOOK_URL=https://n8n.yourdomain.com/
   ```

2. **Configure DNS:**
   - Point your domain to your server's IP address.
   - Caddy will automatically handle SSL certificates.
