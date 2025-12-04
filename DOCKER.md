# Stocky Inventory Management System - Docker Setup

This directory contains Docker configuration files for running Stocky in containers.

## Quick Start

1. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Generate application key:**
   ```bash
   docker-compose run --rm app php artisan key:generate
   ```

3. **Install Passport (OAuth2):**
   ```bash
   docker-compose run --rm app php artisan passport:install
   ```

4. **Start the application:**
   ```bash
   docker-compose up -d
   ```

5. **Access the application:**
   - Application: http://localhost:8000
   - Database: localhost:3306
   - Redis: localhost:6379

## Services

### App (Laravel + Apache)
- **Port:** 8000 (configurable via `APP_PORT` in .env)
- **Purpose:** Main web application
- **Health:** Depends on database and Redis

### Database (MySQL 8.0)
- **Port:** 3306 (configurable via `DB_PORT` in .env)
- **Purpose:** Primary database
- **Volume:** `db-data` (persistent)
- **Default credentials:**
  - Database: `stocky`
  - User: `stocky_user`
  - Password: `secret` (change in .env)

### Redis
- **Port:** 6379 (configurable via `REDIS_PORT` in .env)
- **Purpose:** Cache, sessions, and queue backend
- **Volume:** `redis-data` (persistent)

### Queue Worker
- **Purpose:** Process background jobs (emails, notifications, etc.)
- **Command:** `php artisan queue:work`

### Scheduler
- **Purpose:** Run Laravel scheduled tasks (cron jobs)
- **Command:** `php artisan schedule:run` (every minute)

## Environment Variables

Key environment variables to configure in `.env`:

```env
# Application
APP_NAME=Stocky
APP_ENV=production
APP_KEY=                    # Generate with: php artisan key:generate
APP_DEBUG=false
APP_URL=http://localhost:8000
APP_PORT=8000

# Database
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=stocky
DB_USERNAME=stocky_user
DB_PASSWORD=secret          # CHANGE THIS!

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# Cache & Session
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Mail (configure for your SMTP provider)
MAIL_MAILER=smtp
MAIL_HOST=
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=
MAIL_FROM_NAME="${APP_NAME}"

# Passport OAuth2
PASSPORT_PERSONAL_ACCESS_CLIENT_ID=
PASSPORT_PERSONAL_ACCESS_CLIENT_SECRET=
```

## Common Commands

### Build and Start
```bash
# Build images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop all services
docker-compose down
```

### Database Management
```bash
# Run migrations
docker-compose exec app php artisan migrate

# Seed database
docker-compose exec app php artisan db:seed

# Fresh migration with seed
docker-compose exec app php artisan migrate:fresh --seed

# Create database backup
docker-compose exec db mysqldump -u stocky_user -psecret stocky > backup.sql
```

### Application Management
```bash
# Clear cache
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear

# Optimize for production
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache

# Generate Passport keys
docker-compose exec app php artisan passport:install

# Create admin user (if seeder available)
docker-compose exec app php artisan db:seed --class=UserSeeder
```

### Queue and Scheduler
```bash
# View queue worker logs
docker-compose logs -f queue

# Restart queue worker
docker-compose restart queue

# View scheduler logs
docker-compose logs -f scheduler
```

### File Permissions
```bash
# Fix storage permissions (if needed)
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

## Production Deployment

### Security Checklist
- [ ] Change all default passwords in `.env`
- [ ] Set `APP_DEBUG=false`
- [ ] Set `APP_ENV=production`
- [ ] Configure proper `APP_URL`
- [ ] Set up SSL/TLS certificates
- [ ] Configure firewall rules
- [ ] Set up automated backups
- [ ] Configure mail settings
- [ ] Review and update `CORS` settings
- [ ] Enable rate limiting

### Performance Optimization
```bash
# Cache configuration
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan view:cache

# Optimize composer autoloader
docker-compose exec app composer dump-autoload --optimize
```

### Backup Strategy
```bash
# Database backup
docker-compose exec db mysqldump -u stocky_user -p stocky | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz

# Application files backup
tar -czf stocky_files_$(date +%Y%m%d_%H%M%S).tar.gz storage/ public/images/ public/uploads/
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs app
docker-compose logs db

# Check container status
docker-compose ps
```

### Database connection issues
```bash
# Verify database is healthy
docker-compose exec db mysqladmin ping -h localhost -u root -p

# Check database exists
docker-compose exec db mysql -u root -p -e "SHOW DATABASES;"
```

### Permission issues
```bash
# Reset permissions
docker-compose exec app chown -R www-data:www-data /var/www/html
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

### Clear all data and restart
```bash
# Stop and remove containers, volumes
docker-compose down -v

# Rebuild and start
docker-compose up -d --build
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Load Balancer                       │
│                    (Nginx/Traefik)                      │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
┌────────▼────────┐    ┌────────▼────────┐
│   App Service   │    │  Queue Worker   │
│  (Laravel+Vue)  │    │   (Background)  │
└────────┬────────┘    └────────┬────────┘
         │                      │
         └──────────┬───────────┘
                    │
         ┌──────────┼──────────┐
         │          │          │
    ┌────▼───┐ ┌───▼────┐ ┌──▼──────┐
    │ MySQL  │ │ Redis  │ │Scheduler│
    │   DB   │ │ Cache  │ │  (Cron) │
    └────────┘ └────────┘ └─────────┘
```

## Support

For issues specific to Docker setup, check:
- Docker logs: `docker-compose logs`
- Laravel logs: `storage/logs/laravel.log`
- Apache logs: `docker-compose exec app tail -f /var/log/apache2/error.log`

For Stocky-specific issues, refer to the main documentation.
