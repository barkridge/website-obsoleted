FROM node:lts

WORKDIR /var/www/html

COPY package.json .

RUN yarn install

COPY . .

RUN yarn build

FROM composer:2

WORKDIR /var/www/html

COPY . .

RUN composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

FROM php:8.1-apache-buster

ENV APACHE_DOCUMENT_ROOT="/var/www/html/public"

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y libpq-dev
RUN docker-php-ext-configure opcache --enable-opcache
RUN docker-php-ext-install pdo pdo_pgsql pgsql
RUN a2enmod rewrite

COPY --from=1 /var/www/html /var/www/html
COPY --from=0 /var/www/html/public /var/www/html/public

RUN chown -R www-data:www-data bootstrap/cache
RUN chown -R www-data:www-data storage

RUN chmod -R 775 bootstrap/cache
RUN chmod -R 775 storage

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN sed -ri -e 's!upload_max_filesize = 2M!upload_max_filesize = 16M!g' /usr/local/etc/php/php.ini-development
RUN sed -ri -e 's!post_max_size = 8M!post_max_size = 64M!g' /usr/local/etc/php/php.ini-development

RUN sed -ri -e 's!upload_max_filesize = 2M!upload_max_filesize = 16M!g' /usr/local/etc/php/php.ini-production
RUN sed -ri -e 's!post_max_size = 8M!post_max_size = 64M!g' /usr/local/etc/php/php.ini-production
