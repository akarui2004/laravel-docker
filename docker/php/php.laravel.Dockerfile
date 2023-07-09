FROM php:8.1-fpm

WORKDIR /code/Example

RUN apt-get -y update

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

# Install zip
RUN apt-get install -y zip unzip libzip-dev
RUN docker-php-ext-install zip

# Install postgres
RUN apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

COPY . .

RUN addgroup -g 1000 --system laravel
RUN adduser -G laravel --system -D -s /bin/sh -u 1000 laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf

USER laravel

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
