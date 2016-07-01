FROM ubuntu:14.04
MAINTAINER Manuel Reschke <manuel.reschke@unister.de>

########################################################################################################################
### Install base packages and basic php extensions
########################################################################################################################
ENV DEBIAN_FRONTEND noninteractive
# SUPERVISOR + APACHE2
RUN apt-get update && \
    apt-get -y install supervisor \
    apache2 \
    libapache2-mod-php5 \
    openssl

# PHP
RUN apt-get -y install curl \
    php5 \
    php5-cgi \
    php5-cli \
    php5-common \
    php5-fpm \
    php-pear \
    php5-mysql \
    php5-curl \
    php5-dev \
    php5-mcrypt \
    php5-xmlrpc \
    php5-memcached \
    php5-xdebug

# OPEN SSH
RUN apt-get -y install openssh-server

# CLEAN UP
RUN apt-get clean

########################################################################################################################
### Apache and Supervisor configuration
########################################################################################################################
ADD ./build/docker/start.sh /start.sh
ADD ./build/docker/start-apache2.sh /start-apache2.sh
RUN chmod 755 /*.sh
RUN mkdir -p /etc/supervisor/conf.d
ADD ./build/docker/supervisor-apache2.conf /etc/supervisor/conf.d/apache2.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
ADD ./build/docker/vhost-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod deflate
RUN a2enmod env
RUN a2enmod expires

########################################################################################################################
#### Configure xdebug extension
########################################################################################################################
COPY ./build/docker/xdebug.ini /etc/php5/mods-available/xdebug.ini

########################################################################################################################
### Set and overwrite default php settings
########################################################################################################################
COPY ./build/docker/php.ini /etc/php5/apache2/php.ini

########################################################################################################################
#### Mount default Folders
########################################################################################################################
VOLUME ["/var/www/html", "/var/log/apache2"]

########################################################################################################################
#### Listen on Port 80
########################################################################################################################
EXPOSE 80

########################################################################################################################
#### Run
########################################################################################################################
CMD ["/bin/bash", "/start.sh"]