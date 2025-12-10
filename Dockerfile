# Simple Dockerfile for Stocky Inventory Management System
FROM php:8.3-apache

# Install system dependencies and PHP extensions in one layer
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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        zip \
        xml \
        calendar \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Install Node.js 14 using NVM (NodeSource doesn't support Node 14 on Debian Trixie)
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=14.21.3
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

# Add node and npm to path
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Set working directory
WORKDIR /var/www/html

# Configure Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy application files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Note: Build frontend assets locally before building Docker image
# Run: npm install && npm run prod

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && echo "upload_max_filesize = 100M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "post_max_size = 100M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "memory_limit = 256M" >> "$PHP_INI_DIR/conf.d/uploads.ini" \
    && echo "max_execution_time = 300" >> "$PHP_INI_DIR/conf.d/uploads.ini"

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Create entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Waiting for database..."\n\
until php -r "try { new PDO(\"mysql:host=${DB_HOST};port=${DB_PORT:-3306};dbname=${DB_DATABASE}\", \"${DB_USERNAME}\", \"${DB_PASSWORD}\"); } catch(PDOException \$e) { fwrite(STDERR, \"Connection failed: \" . \$e->getMessage() . \"\n\"); exit(1); }"; do\n\
    echo "Database is unavailable - sleeping"\n\
    sleep 2\n\
done\n\
echo "Database is ready!"\n\
php artisan migrate --force\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
exec apache2-foreground' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

USER www-data

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
