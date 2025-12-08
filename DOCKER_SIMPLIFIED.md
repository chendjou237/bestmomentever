# Simplified Docker Setup for Stocky v4.0.8

## Overview

This is a simplified Docker configuration with only the essential services needed to run Stocky Inventory Management System.

## What's Included

### Services (2 total)
1. **app** - Laravel application with Apache (PHP 8.2)
2. **db** - MySQL 8.0 database

### What Was Removed
- ❌ Redis (cache/session/queue)
- ❌ Queue worker service
- ❌ Scheduler service (cron jobs)

## Architecture

```
┌─────────────────┐
│   App Service   │
│  Laravel + Vue  │
│  PHP 8.2-Apache │
│  Port: 8000     │
└────────┬────────┘
         │
         │
    ┌────▼────┐
    │  MySQL  │
    │   8.0   │
    │Port:3306│
    └─────────┘
```

## Configuration Changes

### Cache & Sessions
- **Before**: Redis-based (distributed)
- **After**: File-based (local storage)
- **Location**: `storage/framework/cache` and `storage/framework/sessions`

### Queue Processing
- **Before**: Redis queue with background worker
- **After**: Synchronous processing (immediate execution)
- **Impact**: Emails and notifications sent immediately, no background processing

### Scheduled Tasks
- **Before**: Dedicated scheduler service
- **After**: None (manual execution required)
- **Note**: If you need cron jobs, set them up on the host system

## Quick Start

```bash
# 1. Copy environment file
cp .env.docker.example .env

# 2. Update database password in .env
# Edit DB_PASSWORD=your_secure_password

# 3. Build and start
docker-compose up -d

# 4. Generate app key
docker-compose exec app php artisan key:generate

# 5. Run migrations
docker-compose exec app php artisan migrate

# 6. Install Passport
docker-compose exec app php artisan passport:install

# 7. Access application
open http://localhost:8000
```

## Or Use Makefile

```bash
# Install everything
make install

# Start services
make up

# View logs
make logs

# Stop services
make down
```

## Environment Variables

Key settings in `.env`:

```env
# Cache & Session (file-based)
CACHE_DRIVER=file
SESSION_DRIVER=file

# Queue (synchronous)
QUEUE_CONNECTION=sync

# Database
DB_HOST=db
DB_PORT=3306
DB_DATABASE=stocky
DB_USERNAME=stocky_user
DB_PASSWORD=your_secure_password
```

## Performance Considerations

### Advantages of Simplified Setup
- ✅ Easier to understand and maintain
- ✅ Fewer moving parts
- ✅ Lower resource usage
- ✅ Simpler troubleshooting
- ✅ Good for small to medium deployments

### Limitations
- ⚠️ File-based cache is slower than Redis
- ⚠️ No background job processing
- ⚠️ Emails sent synchronously (slower response times)
- ⚠️ No automatic scheduled tasks
- ⚠️ Sessions not shared across multiple app instances

## When to Upgrade

Consider adding Redis, queue workers, and scheduler if:
- You have high traffic (100+ concurrent users)
- You need background email processing
- You need scheduled tasks (reports, cleanup, etc.)
- You need to scale horizontally (multiple app instances)
- You need distributed caching

## Upgrading to Full Setup

If you need the full setup later, you can:

1. Add Redis service to `compose.yaml`
2. Add queue worker service
3. Add scheduler service
4. Update `.env`:
   ```env
   CACHE_DRIVER=redis
   SESSION_DRIVER=redis
   QUEUE_CONNECTION=redis
   REDIS_HOST=redis
   ```

See `DOCKER_REVIEW.md` for the full configuration.

## File Structure

```
.
├── Dockerfile              # Multi-stage build (frontend + backend)
├── compose.yaml            # Docker Compose (app + db only)
├── .env.docker.example     # Environment template
├── .dockerignore          # Build exclusions
├── docker/
│   └── mysql/
│       └── my.cnf         # MySQL configuration
├── DOCKER.md              # This documentation
└── Makefile               # Convenience commands
```

## Common Tasks

### Database Backup
```bash
make backup
# or
docker-compose exec db mysqldump -u stocky_user -p stocky > backup.sql
```

### Database Restore
```bash
make restore FILE=backup.sql.gz
```

### Clear Cache
```bash
make cache-clear
```

### Fix Permissions
```bash
make fix-permissions
```

### View Logs
```bash
make logs
# or
docker-compose logs -f app
```

## Troubleshooting

### Application is slow
- File-based cache is slower than Redis
- Consider upgrading to Redis if performance is critical

### Emails not sending
- Check SMTP configuration in `.env`
- Check logs: `docker-compose logs app`
- Emails are sent synchronously, so they may slow down requests

### Database connection failed
```bash
# Check database is running
docker-compose ps

# Check database logs
docker-compose logs db

# Test connection
docker-compose exec db mysqladmin ping -h localhost -u root -p
```

### Permission errors
```bash
# Fix storage permissions
make fix-permissions
```

## Production Checklist

- [ ] Change `DB_PASSWORD` to a strong password
- [ ] Set `APP_DEBUG=false`
- [ ] Set `APP_ENV=production`
- [ ] Configure proper `APP_URL`
- [ ] Set up SSL/TLS (use nginx reverse proxy)
- [ ] Configure mail settings
- [ ] Set up automated database backups
- [ ] Monitor disk space (file cache grows over time)
- [ ] Set up log rotation

## Resource Requirements

### Minimum
- CPU: 1 core
- RAM: 1GB
- Disk: 10GB

### Recommended
- CPU: 2 cores
- RAM: 2GB
- Disk: 20GB

## Support

For issues:
- Check `DOCKER.md` for detailed documentation
- Review logs: `docker-compose logs`
- Check Laravel logs: `storage/logs/laravel.log`

---

**Version**: Simplified v1.0
**Date**: 2025-12-08
**For**: Stocky Inventory Management System v4.0.8
