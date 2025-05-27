# Load environment variables from .env file if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: help init up down restart logs backup restore clean-restore drop-db create-db scale

# Show this help message
help:
	@echo "Available commands:"
	@echo "  help          Show this help message"
	@echo "  init          Initialize directories, permissions, and .env file"
	@echo "  up            Start all services"
	@echo "  down          Stop all services"
	@echo "  restart       Restart all services"
	@echo "  logs          View logs from all services"
	@echo "  backup        Backup PostgreSQL database"
	@echo "  restore       Restore PostgreSQL database (usage: make restore FILE=backup.sql)"
	@echo "  clean-restore Clean restore - drop database, recreate and restore (usage: make clean-restore FILE=backup.sql)"
	@echo "  drop-db       Drop n8n database (WARNING: destroys all data)"
	@echo "  create-db     Create n8n database"
	@echo "  scale         Scale n8n-worker instances (usage: make scale WORKERS=n)"

# Initialize directories, permissions, and .env file
init:
	@chmod +x ./script/init.sh
	@./script/init.sh

# Start all services
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Restart all services
restart:
	docker compose restart

# View logs from all services
logs:
	docker compose logs -f

# Backup PostgreSQL database
backup:
	@echo "Creating database backup..."
	docker compose exec postgres pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Backup completed: backup_$(shell date +%Y%m%d_%H%M%S).sql"

# Restore PostgreSQL database (usage: make restore FILE=backup.sql)
restore:
	@if [ -z "$(FILE)" ]; then echo "Usage: make restore FILE=backup.sql"; exit 1; fi
	@echo "Restoring database from $(FILE)..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "Restore completed"

# Clean restore - drop database, recreate and restore (usage: make clean-restore FILE=backup.sql)
clean-restore:
	@if [ -z "$(FILE)" ]; then echo "Usage: make clean-restore FILE=backup.sql"; exit 1; fi
	@echo "Performing clean restore from $(FILE)..."
	@echo "This will destroy all existing data!"
	@read -p "Are you sure? [y/N]: " confirm && [ "$$confirm" = "y" ] || exit 1
	$(MAKE) drop-db
	$(MAKE) create-db
	@echo "Restoring database from $(FILE)..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "Clean restore completed"

# Drop n8n database (WARNING: destroys all data)
drop-db:
	@echo "Dropping database..."
	@echo "Terminating all connections to database..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$(POSTGRES_DB)' AND pid <> pg_backend_pid();"
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "DROP DATABASE IF EXISTS $(POSTGRES_DB);"
	@echo "Database dropped"

# Create n8n database
create-db:
	@echo "Creating database..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "CREATE DATABASE $(POSTGRES_DB) OWNER $(POSTGRES_NON_ROOT_USER);"
	@echo "Database created"

# Scale n8n-worker instances
scale:
	docker compose up -d --scale n8n-worker=$(WORKERS)
	@echo "Scaled n8n-worker to $(WORKERS) instances."
