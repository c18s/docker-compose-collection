# Load environment variables from .env file if it exists
ifneq (,$(wildcard ./.env))
		include .env
		export
endif

.PHONY: help init start stop restart logs backup restore clean-restore drop-db create-db scale

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } END {printf "\n"}' $(MAKEFILE_LIST)

##@ Setup and Initialization

init: ## Initialize directories, permissions, and .env file
	@echo "Initializing directories and permissions..."
	@bash script/init.sh

##@ Service Management

start: ## Start all services
	docker compose up -d

stop: ## Stop all services
	docker compose down

restart: stop start ## Restart all services (stop then start)

##@ Monitoring

logs: ## View logs from all services
	docker compose logs -f

##@ Database Operations

backup: ## Backup PostgreSQL database
	@echo "Creating database backup..."
	docker compose exec postgres pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Backup completed: backup_$(shell date +%Y%m%d_%H%M%S).sql"

restore: ## Restore PostgreSQL database (usage: make restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then echo "Usage: make restore FILE=backup.sql"; exit 1; fi
	@echo "Restoring database from $(FILE)..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "Restore completed"

clean-restore: ## Clean restore - drop database, recreate and restore (usage: make clean-restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then echo "Usage: make clean-restore FILE=backup.sql"; exit 1; fi
	@echo "Performing clean restore from $(FILE)..."
	@echo "This will destroy all existing data!"
	@read -p "Are you sure? [y/N]: " confirm && [ "$$confirm" = "y" ] || exit 1
	$(MAKE) drop-db
	$(MAKE) create-db
	@echo "Restoring database from $(FILE)..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "Clean restore completed"

drop-db: ## Drop n8n database (WARNING: destroys all data)
	@echo "Dropping database..."
	@echo "Terminating all connections to database..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$(POSTGRES_DB)' AND pid <> pg_backend_pid();"
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "DROP DATABASE IF EXISTS $(POSTGRES_DB);"
	@echo "Database dropped"

create-db: ## Create n8n database
	@echo "Creating database..."
	docker compose exec -T postgres psql -U $(POSTGRES_USER) -d postgres -c "CREATE DATABASE $(POSTGRES_DB) OWNER $(POSTGRES_NON_ROOT_USER);"
	@echo "Database created"

##@ Scaling

scale: ## Scale n8n-worker instances (usage: make scale WORKERS=n)
	docker compose up -d --scale n8n-worker=$(WORKERS)
	@echo "Scaled n8n-worker to $(WORKERS) instances."
