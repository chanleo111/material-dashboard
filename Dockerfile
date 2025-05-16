FROM php:8.2-fpm

# 安裝系統依賴和 PHP 擴展
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libzip-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    nodejs \
    curl \
    npm\
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 設置工作目錄
WORKDIR /var/www/html

# 複製項目文件
COPY . /var/www/html

RUN npm install
# 安裝 Laravel 依賴
RUN composer install --optimize-autoloader --no-dev

# 設置權限
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 暴露端口（PHP-FPM）
EXPOSE 9000

CMD ["php-fpm"]