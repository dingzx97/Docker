FROM php:7-fpm-alpine

ENV MACCMS_VERSION="2025.1000.4047"

RUN wget https://github.com/magicblack/maccms10/archive/refs/tags/v${MACCMS_VERSION}.zip -O /tmp/maccms.zip; \
    unzip -q /tmp/maccms.zip -d /tmp; \
    mv /tmp/maccms10-${MACCMS_VERSION}/* /var/www/html; \
    chown -R www-data:data /var/www/html; \
    rm -rf /tmp/*;

RUN apk add --no-cache libzip-dev libpng-dev freetype-dev; \
    docker-php-ext-configure gd --with-freetype=/usr/include/; \
    docker-php-ext-install -j$(nproc) pdo_mysql zip gd;