# Usa una imagen base de PHP con Apache
FROM php:8.1-apache

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    curl \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mbstring zip gd \
    && a2enmod rewrite

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto
COPY . .

# Instala dependencias y compila assets
RUN composer install --no-interaction --optimize-autoloader
RUN npm install
RUN npm run build

# Genera los archivos de caché y la clave de la aplicación
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
RUN php artisan key:generate

# Configura permisos
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache

# Copia el archivo de configuración de Apache para Laravel y activa el sitio
COPY docker-config/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default

# CMD de inicio
CMD ["apache2-foreground"]