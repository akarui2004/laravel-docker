FROM php:8.1-fpm

WORKDIR /code/Example

RUN apt-get -y update

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install zip
RUN apt-get install -y zip unzip libzip-dev
RUN docker-php-ext-install zip

# Install postgres
RUN apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

COPY . .

RUN sed -i "s/user = www-data/user = root/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = root/g" /usr/local/etc/php-fpm.d/www.conf

USER root

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
