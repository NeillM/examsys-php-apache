FROM php:7.4-apache

# Install the php extensions and nodjs.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
&& apt-get install --no-install-recommends -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libldap-dev \
    ssl-cert gnupg \
    libzip-dev \
    libonig-dev \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-install curl xml xmlrpc mysqli intl ldap mbstring zip pdo_mysql sockets \
&& apt-get update \
&& apt-get install --no-install-recommends -y libmemcached-dev \
&& pecl install memcached xdebug \
&& docker-php-ext-enable memcached xdebug \
&& apt-get install --no-install-recommends -y nodejs \
&& curl -sL  https://www.npmjs.com/install.sh | bash - \
&& npm config set bin-links false \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# create virtual hosts
COPY conf/rogo.conf /etc/apache2/sites-available/rogo.conf

# enable apache mods, and setup the virtual hosts
RUN a2enmod rewrite \
&& a2enmod ssl \
&& a2dissite 000-default \
&& a2ensite rogo \
&& rm -rf /var/www/html

# rogo php settings
COPY conf/rogo.ini /usr/local/etc/php/conf.d/rogo.ini

# restart apache, then configure directories and install nodejs.
RUN service apache2 restart \
&& mkdir /rogodata \
&& chown -R www-data:www-data /rogodata \
&& mkdir /rogodataunit \
&& chown -R www-data:www-data /rogodataunit \
&& mkdir /rogodatabehat \
&& chown -R www-data:www-data /rogodatabehat

WORKDIR /var/www
