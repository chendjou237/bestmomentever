#!/bin/bash
set -e

echo "Waiting for database..."

# Set default port if not provided
: ${DB_PORT:=3306}

# Wait for database to be ready
until php -r "
try {
    new PDO(
        'mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT') . ';dbname=' . getenv('DB_DATABASE'),
        getenv('DB_USERNAME'),
        getenv('DB_PASSWORD')
    );
    exit(0);
} catch(PDOException \$e) {
    fwrite(STDERR, 'Connection failed: ' . \$e->getMessage() . PHP_EOL);
    exit(1);
}
"; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is ready!"

# Run Laravel setup commands
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start Apache
exec apache2-foreground
