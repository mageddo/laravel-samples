FROM php:5.5-apache
MAINTAINER Florian Bender <fb+dockerhub@quantumedia.de>

# Install gd, iconv, mbstring, mcrypt, mysql, soap, sockets, zip, and zlib extensions
# see example at https://hub.docker.com/_/php/
RUN apt-get update && apt-get install -y \
        libbz2-dev \
        libfreetype6-dev \
        libgd-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        zlib1g-dev \
        php5-sqlite \
    && docker-php-ext-install iconv mbstring mcrypt soap sockets zip \
    && docker-php-ext-configure gd --enable-gd-native-ttf --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd pdo pdo_mysql

# Add a PHP config file. The file was copied from a php53 dotdeb package and
# lightly modified (mostly for improving debugging). This may not be the best
# idea.
COPY php.ini /usr/local/etc/php/

RUN curl -L https://getcomposer.org/download/1.2.3/composer.phar > /usr/local/bin/composer && \
	chmod +x /usr/local/bin/composer && composer global require "laravel/installer=~1.1"

# enable mod_rewrite
RUN a2enmod rewrite

# make the webroot a volume
VOLUME /var/www/html/

# In images building upon this image, copy the src/ directory to the webserver
# root and correct the owner.
ONBUILD COPY src/ /var/www/html/
ONBUILD RUN chown -R www-data:www-data /var/www/html

# support jwilder/nginx-proxy resp. docker-gen
# You may wan to overwrite VIRTUAL_HOST and UPSTREAM_NAME in your Docker file.
EXPOSE 80
ENV VIRTUAL_HOST site.local
ENV UPSTREAM_NAME web-site

# Put something like this into your Dockerfile if you want to add more files.
# Note that you need to correctly set the owner otherwise PHP will not be able
# to edit the file system.
## copy src-extra
#COPY src-extra/ /var/www/html/extra/
#RUN chown -R www-data:www-data /var/www/html/extra

# Entrypoint file tries to fix permissions, again
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
