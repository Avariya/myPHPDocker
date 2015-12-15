FROM php:fpm
MAINTAINER Olexy Romanchenko <avariya1@gmail.com>

RUN apt-get update && apt-get -y install git wget zip zlib1g-dev libmemcached-dev libldap2-dev libcurl4-gnutls-dev libxml2-dev

RUN cd /root && \
    git clone -b php7 https://github.com/php-memcached-dev/php-memcached && \
    cd php-memcached && \
    phpize && \
    ./configure --disable-memcached-sasl && \
    make && \
    make install

RUN cd /root && \
    git clone -b NON_BLOCKING_IO_php7 https://github.com/websupport-sk/pecl-memcache && \
    cd pecl-memcache && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN ln -sf /usr/lib/x86_64-linux-gnu/libl* /usr/lib/ && docker-php-ext-install xml curl zip pdo_mysql 

RUN echo "extension=memcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-memcache.ini && \
    echo "extension=memcached.so" > /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN apt-get -y remove --purge wget zip zlib1g-dev libsqlite3-dev libldap2-dev libcurl4-gnutls-dev libxml2-dev && apt-get -y autoremove && apt-get clean

COPY src/php-fpm.conf /etc/php/7.0/fpm/
COPY src/php-fpm.conf /usr/local/

EXPOSE 9000

CMD ["php-fpm"]

