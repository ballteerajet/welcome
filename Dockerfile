# Step 1: Choose a base image
FROM php:8.1-fpm

# Step 2: Install dependencies
RUN apt-get update && apt-get install -y \
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

# Step 7: Set permissions for Laravel
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# Step 8: Expose the port for Nginx/Apache
EXPOSE 80

# Step 9: Run the PHP server
CMD ["php-fpm"]
