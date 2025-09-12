FROM php:8.3-apache

ENV NODE_VERSION=22.14.0
ENV NVM_LOC="/root/.nvm/"

# Configure virtual hosts
COPY conf/rogo.conf /etc/apache2/sites-available/rogo.conf

# PHP settings
COPY conf/rogo.ini /usr/local/etc/php/conf.d/rogo.ini

# Install and configure everything!
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
&& apt-get install --no-install-recommends -y \
    acl="2.3.*" \
    gnupg="2.4.*" \
    git="1:2.47.*" \
    libicu-dev="76.*" \
    libcurl4-openssl-dev="8.14.*" \
    libfreetype-dev="2.13.*" \
    libjpeg62-turbo-dev="1:2.1.*" \
    libldap2-dev="2.6.*" \
    libmemcached-dev="1.1.*" \
    libssl-dev="3.5.*" \
    libonig-dev="6.9.*" \
    libpng-dev="1.6.*" \
    libxml2-dev="2.12.*" \
    libzip-dev="1.11.*" \
    ssl-cert="1.1.*" \
# Install PHP extensions.
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j"$(nproc)" gd \
&& docker-php-ext-install \
    intl \
    ldap \
    mysqli \
    pdo_mysql \
    sockets \
# Install the zip extension to allow composer to download packages more efficiently.
    zip \
&& pecl install \
    memcached \
    xdebug \
# Install even if it is a beta version (we should periodically check to see if there are non-beta versions available).
&& pecl install -f xmlrpc \
&& docker-php-ext-enable \
    memcached \
    xdebug \
    xmlrpc \
# Install node.js via nvm
&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
&& source "${NVM_LOC}nvm.sh" \
&& nvm install ${NODE_VERSION} \
&& nvm use v${NODE_VERSION} \
&& nvm alias default v${NODE_VERSION} \
# Cannot have sym links in docker.
&& npm config set bin-links false \
# Install grunt globally.
&& npm install -g grunt-cli@1.4.3 \
# Clean up apt files to reduce the size of the image.
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# Enable Apache modules.
&& a2enmod rewrite \
&& a2enmod ssl \
# Use the ExamSys virtual hosts configuration.
&& a2dissite 000-default \
&& a2ensite rogo
# Setup various directories that can be used by ExamSys.
# We also force them to have a specific set of group permissions so that the
# web server will always have full control.
RUN mkdir /rogodata \
&& chown -R www-data:www-data /rogodata \
&& chmod "=774,g+s" /rogodata \
&& setfacl -d -m g::rwx /rogodata \
&& mkdir /rogodataunit \
&& chown -R www-data:www-data /rogodataunit \
&& chmod "=774,g+s" /rogodataunit \
&& setfacl -d -m g::rwx /rogodataunit \
&& mkdir /rogodatabehat \
&& chown -R www-data:www-data /rogodatabehat \
&& chmod "=774,g+s" /rogodatabehat \
&& setfacl -d -m g::rwx /rogodatabehat \
&& mkdir /faildump \
&& chown -R www-data:www-data /faildump \
&& chmod "=774,g+s" /faildump \
&& setfacl -d -m g::rwx /faildump

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/lib/node_modules/grunt-cli/bin/:${PATH}"

ENV XDEBUG_CONFIG='idekey=examsys'
ENV PHP_IDE_CONFIG='serverName=examsys'

WORKDIR /var/www/html
