# Multi-stage Dockerfile for Stocky Inventory Management System
# Laravel 10 + Vue.js + MySQL

################################################################################
# Stage 1: Build Frontend Assets
################################################################################
FROM node:18-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including devDependencies for build)
RUN npm ci

# Copy source files needed for build
COPY resources ./resources
COPY webpack.mix.js ./
COPY .babelrc* ./

# Build production assets
RUN npm run prod

################################################################################
# Stage 2: Install PHP Dependencies
################################################################################
FROM composer:2.6 AS php-deps

WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install PHP dependencies (production only)
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-autoloader \
    --prefer-dist \
    --optimize-autoloader

################################################################################
# Stage 3: Final Production Image
################################################################################
FROM php:8.2-apache AS final

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by Laravel and Stocky
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    xml \
    tokenizer \
    ctype \
    json \
    fileinfo

# Enable Apache modules
RUN a2enmod rewrite headers

# Configure Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set working directory
WORKDIR /var/www/html

# Copy vendor from composer stage
COPY --from=php-deps /app/vendor ./vendor

# Copy built frontend assets from frontend-builder stage
COPY --from=frontend-builder /app/public/css ./public/css
COPY --from=frontend-builder /app/public/js ./public/js
COPY --from=frontend-builder /app/public/mix-manifest.json ./public/mix-manifest.json

# Copy application files
COPY . .

# Copy production PHP configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Create custom PHP configuration for Laravel
RUN echo "upload_max_filesize = 100M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "post_max_size = 100M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "memory_limit = 256M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "max_execution_time = 300" >> "$PHP_INI_DIR/conf.d/uploads.ini"

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Generate optimized autoloader
RUN composer dump-autoload --optimize --no-dev

# Create entrypoint script
COPY <<'EOF' /usr/local/bin/docker-entrypoint.sh
#!/bin/bash
set -e

# Wait for database to be ready
echo "Waiting for database..."
until php artisan migrate:status 2>/dev/null; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is ready!"

# Run migrations
php artisan migrate --force

# Cache configuration
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start Apache
exec apache2-foreground
EOF

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Switch to non-privileged user
USER www-data

# Expose port 80
EXPOSE 80

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
