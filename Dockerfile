# Usa una imagen base de PHP con Apache
FROM php:8.1-apache

# Instala Node.js y otras dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    # Instala Node.js y npm usando NodeSource
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mbstring zip gd \
    && a2enmod rewrite

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto al contenedor
COPY . .
# Copia el archivo de configuración de Apache
COPY docker-config/000-default.conf /etc/apache2/sites-available/000-default.conf
# Instala las dependencias de Composer y Node
RUN composer install --no-interaction --optimize-autoloader
RUN npm install
RUN npm run build

# Configura las variables de entorno para Laravel
RUN cp .env.example .env

# Asegura los permisos correctos
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache \
    /var/www/html/.env

# Genera la clave de la aplicación
RUN php artisan key:generate

# Expone el puerto 80 para Apache
EXPOSE 80