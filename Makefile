# Makefile for Stocky Docker Management
# Usage: make [target]

.PHONY: help build up down restart logs shell db-shell redis-cli migrate seed fresh install clean backup restore

# Default target
.DEFAULT_GOAL := help

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Stocky Docker Management$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

# Build and Start
build: ## Build Docker images
	@echo "$(BLUE)Building Docker images...$(NC)"
	docker-compose build

up: ## Start all services
	@echo "$(BLUE)Starting services...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)Services started!$(NC)"
	@echo "Application: http://localhost:8000"

down: ## Stop all services
	@echo "$(BLUE)Stopping services...$(NC)"
	docker-compose down
	@echo "$(GREEN)Services stopped!$(NC)"

restart: ## Restart all services
	@echo "$(BLUE)Restarting services...$(NC)"
	docker-compose restart
	@echo "$(GREEN)Services restarted!$(NC)"

# Logs
logs: ## View logs from all services
	docker-compose logs -f

logs-app: ## View application logs
	docker-compose logs -f app

logs-db: ## View database logs
	docker-compose logs -f db

logs-queue: ## View queue worker logs
	docker-compose logs -f queue

# Shell Access
shell: ## Open shell in app container
	docker-compose exec app bash

db-shell: ## Open MySQL shell
	docker-compose exec db mysql -u stocky_user -p stocky

redis-cli: ## Open Redis CLI
	docker-compose exec redis redis-cli

# Database Operations
migrate: ## Run database migrations
	@echo "$(BLUE)Running migrations...$(NC)"
	docker-compose exec app php artisan migrate
	@echo "$(GREEN)Migrations completed!$(NC)"

migrate-fresh: ## Fresh migration (WARNING: destroys data)
	@echo "$(RED)WARNING: This will destroy all data!$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose exec app php artisan migrate:fresh; \
		echo "$(GREEN)Fresh migration completed!$(NC)"; \
	fi

seed: ## Seed database
	@echo "$(BLUE)Seeding database...$(NC)"
	docker-compose exec app php artisan db:seed
	@echo "$(GREEN)Database seeded!$(NC)"

fresh: migrate-fresh seed ## Fresh migration + seed

# Application Setup
install: ## Initial installation
	@echo "$(BLUE)Installing Stocky...$(NC)"
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)Creating .env file...$(NC)"; \
		cp .env.docker.example .env; \
		echo "$(GREEN).env created! Please update it with your settings.$(NC)"; \
		exit 1; \
	fi
	docker-compose up -d
	@echo "$(YELLOW)Waiting for services to be ready...$(NC)"
	sleep 10
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan migrate
	docker-compose exec app php artisan passport:install
	docker-compose exec app php artisan config:cache
	@echo "$(GREEN)Installation completed!$(NC)"
	@echo "Access your application at: http://localhost:8000"

# Cache Operations
cache-clear: ## Clear all caches
	@echo "$(BLUE)Clearing caches...$(NC)"
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan config:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan view:clear
	@echo "$(GREEN)Caches cleared!$(NC)"

cache-optimize: ## Optimize caches for production
	@echo "$(BLUE)Optimizing caches...$(NC)"
	docker-compose exec app php artisan config:cache
	docker-compose exec app php artisan route:cache
	docker-compose exec app php artisan view:cache
	docker-compose exec app composer dump-autoload --optimize
	@echo "$(GREEN)Caches optimized!$(NC)"

# Backup and Restore
backup: ## Backup database
	@echo "$(BLUE)Creating database backup...$(NC)"
	@mkdir -p backups
	docker-compose exec db mysqldump -u stocky_user -psecret stocky | gzip > backups/stocky_$(shell date +%Y%m%d_%H%M%S).sql.gz
	@echo "$(GREEN)Backup created in backups/ directory$(NC)"

restore: ## Restore database from backup (usage: make restore FILE=backup.sql.gz)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Error: Please specify FILE=backup.sql.gz$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)Restoring database from $(FILE)...$(NC)"
	gunzip < $(FILE) | docker-compose exec -T db mysql -u stocky_user -psecret stocky
	@echo "$(GREEN)Database restored!$(NC)"

# Maintenance
clean: ## Remove all containers, volumes, and images
	@echo "$(RED)WARNING: This will remove all containers, volumes, and images!$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		docker-compose rm -f; \
		echo "$(GREEN)Cleanup completed!$(NC)"; \
	fi

ps: ## Show running containers
	docker-compose ps

stats: ## Show container resource usage
	docker stats

# Development
dev: ## Start in development mode with logs
	docker-compose up

test: ## Run tests
	docker-compose exec app php artisan test

tinker: ## Open Laravel Tinker
	docker-compose exec app php artisan tinker

# Queue Management
queue-restart: ## Restart queue worker
	docker-compose restart queue
	@echo "$(GREEN)Queue worker restarted!$(NC)"

queue-work: ## Run queue worker in foreground
	docker-compose exec app php artisan queue:work

# Permissions
fix-permissions: ## Fix storage permissions
	@echo "$(BLUE)Fixing permissions...$(NC)"
	docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
	docker-compose exec app chmod -R 775 storage bootstrap/cache
	@echo "$(GREEN)Permissions fixed!$(NC)"

# Production
deploy: cache-clear cache-optimize ## Deploy to production
	@echo "$(GREEN)Deployment completed!$(NC)"

# Health Check
health: ## Check service health
	@echo "$(BLUE)Checking service health...$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)Testing database connection...$(NC)"
	@docker-compose exec app php artisan migrate:status || echo "$(RED)Database connection failed!$(NC)"
	@echo ""
	@echo "$(BLUE)Testing Redis connection...$(NC)"
	@docker-compose exec redis redis-cli ping || echo "$(RED)Redis connection failed!$(NC)"
