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
    curl \
    # Instala Node.js y npm usando NodeSource
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
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

# Configura permisos y variables de entorno
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache
RUN cp .env.example .env

# Habilita el módulo de reescritura de Apache
RUN a2enmod rewrite

# Copia el archivo de configuración de Apache para Laravel
COPY docker-config/000-default.conf /etc/apache2/sites-available/000-default.conf

# Asegúrate de que el documento raíz de Apache apunte a la carpeta 'public'
RUN sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
RUN sed -i -e "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf

# Genera la clave de la aplicación
RUN php artisan key:generate

# Expone el puerto
EXPOSE 80

# Inicia el servidor Apache
CMD ["apache2-foreground"]