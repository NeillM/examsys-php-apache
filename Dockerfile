FROM php:7.4-apache

RUN apt-get update
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libcurl4-openssl-dev libxml2-dev libldap-dev ssl-cert gnupg libzip-dev libonig-dev

# enable php extenstions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install curl xml xmlrpc mysqli intl ldap mbstring zip pdo_mysql sockets

# enable memcached php extension
RUN apt-get update && apt-get install -y libmemcached-dev
RUN pecl install memcached xdebug
RUN docker-php-ext-enable memcached xdebug

# create virtual hosts
COPY conf/rogo.conf /etc/apache2/sites-available/rogo.conf

# enable apache mods
RUN a2enmod rewrite
RUN a2enmod ssl

# set Apache virtual hosts
RUN a2dissite 000-default
RUN a2ensite rogo
RUN rm -rf /var/www/html

# rogo php settings
COPY conf/rogo.ini /usr/local/etc/php/conf.d/rogo.ini

# restart apache
RUN service apache2 restart

# create data dirs
RUN mkdir /rogodata
RUN chown -R www-data:www-data /rogodata
RUN mkdir /rogodataunit
RUN chown -R www-data:www-data /rogodataunit
RUN mkdir /rogodatabehat
RUN chown -R www-data:www-data /rogodatabehat

# install node
RUN apt-get install -y nodejs
RUN curl -sL  https://www.npmjs.com/install.sh | bash -

# cannot have sym links in docker
RUN npm config set bin-links false

WORKDIR /var/www
