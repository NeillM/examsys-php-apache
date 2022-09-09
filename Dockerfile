FROM php:7.4-apache

# Install the php extensions and nodjs.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
&& apt-get install --no-install-recommends -y \
    gnupg="2.2.*" \
    libcurl4-openssl-dev="7.74.*" \
    libfreetype6-dev="2.10.*" \
    libjpeg62-turbo-dev="1:2.0.*" \
    libldap2-dev="2.4.*" \
    libmemcached-dev="1.0.*" \
    libonig-dev="6.9.*" \
    libpng-dev="1.6.*" \
    libxml2-dev="2.9.*" \
    libzip-dev="1.7.*" \
    nodejs="12.22.*" \
    ssl-cert="1.1.*" \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-install curl xml xmlrpc mysqli intl ldap mbstring zip pdo_mysql sockets \
&& pecl install memcached xdebug \
&& docker-php-ext-enable memcached xdebug \
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

WORKDIR /var/www/html
