FROM composer:latest AS composer
FROM php:7.4-fpm-alpine

# xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install xdebug-3.0.0 \
    && docker-php-ext-enable xdebug \
    && apk del -f .build-deps

ARG user
ARG uid

RUN echo $uid

# Install system dependencies
RUN  apk update && apk add git \
    curl \
    oniguruma-dev \
    zip \
    unzip \
    zlib-dev \
    libpng-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN adduser -S -G root -u $uid -h /home/$user $user
RUN addgroup -S $user www-data
RUN mkdir -p /home/$user/.composer && \
    chown -R $uid:$uid /home/$user

WORKDIR /app

USER $user