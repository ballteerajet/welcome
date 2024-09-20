# Step 1: Choose a base image
FROM php:8.1-fpm

# Step 2: Install dependencies including Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo mbstring zip exif pcntl bcmath gd

# Step 3: Install Composer
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Step 4: Set working directory
WORKDIR /var/www

# Step 5: Copy the Laravel project
COPY . .

# Step 6: Install project dependencies
RUN composer install --no-dev --optimize-autoloader

# Step 7: Configure Nginx
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Step 8: Set permissions for Laravel
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# Step 9: Expose ports
EXPOSE 80

# Step 10: Start Nginx and PHP-FPM together
CMD service nginx start && php-fpm
