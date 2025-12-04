---
trigger: always_on
---

FILE ORGANIZATION RULES

WHEN CREATING NEW FEATURES

Backend:
- Controller: Place in app/Http/Controllers/ or app/Http/Controllers/hrm/ for HRM features
- Model: Place in app/Models/
- Migration: Create in database/migrations/ with timestamp prefix
- Policy: Create in app/Policies/ if authorization needed
- Routes: Add to routes/api.php within appropriate middleware group

Frontend:
- Views: Create in resources/src/views/app/pages/{module}/
- Components: Reusable components in resources/src/components/
- Routes: Add to resources/src/router.js following existing patterns
- Store: Add Vuex module in resources/src/store/ if needed
- Translations: Add keys to all language files in resources/src/translations/

NAMING PATTERNS TO FOLLOW:
- Migration files: YYYY_MM_DD_HHMMSS_create_table_name_table.php
- Controller methods: Follow RESTful conventions (index, store, show, update, destroy)
- API routes: Use snake_case and group by resource
- Vue components: Use snake_case for files, PascalCase for component names

DEVELOPMENT WORKFLOW

Setup & Installation:
# Backend setup
composer install
php artisan key:generate
php artisan passport:install
php artisan migrate --seed

# Frontend setup
npm install
npm run dev  # Development build
npm run prod # Production build

Running the Application:
# Development
php artisan serve
npm run watch  # Watch for changes

# Production
npm run prod
# Configure web server (Apache/Nginx)

Database Management:
# Run migrations
php artisan migrate

# Rollback
php artisan migrate:rollback

# Fresh migration with seed
php artisan migrate:fresh --seed

# Generate migration from existing database
php artisan migrate:generate

Cache Management:
# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Or use the built-in endpoint
GET /api/clear_cache
