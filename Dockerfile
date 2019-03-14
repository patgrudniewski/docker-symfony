ARG PHP_VER=7.3
FROM php:$PHP_VER-alpine

ARG SYMFONY_VER=4.2
ENV SYMFONY_VER=$SYMFONY_VER

RUN wget -O /tmp/composer-setup.php https://getcomposer.org/installer && \
    php /tmp/composer-setup.php && \
    rm -f /tmp/composer-setup.php && \
    mv composer.phar /usr/bin/composer

RUN apk update && \
    apk add \
        nodejs
COPY ./bin/* /usr/bin/

RUN apk add \
        libzip-dev \
        zlib-dev && \
    docker-php-ext-install \
        zip && \
    mkdir -p /usr/local/src/symfony && \
    chown www-data:www-data /usr/local/src/symfony && \
    cd /usr/local/src/symfony && \
    su www-data -s /bin/sh -c "composer create-project symfony/website-skeleton:$SYMFONY_VER\.x $SYMFONY_VER"

WORKDIR /usr/local/src/symfony/$SYMFONY_VER
USER www-data
