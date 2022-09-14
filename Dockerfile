FROM php:7.4-apache

RUN apt-get update \
    && apt-get install  -y  \
	pkg-config \
	zip zlib1g-dev libzip-dev sendmail\ 
	curl \ 
	libonig-dev \ 
#	soap \
	ca-certificates   

# gd
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	# && docker-php-ext-configure gd \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
	
RUN docker-php-ext-install session mysqli json opcache sockets pdo pdo_mysql
RUN a2enmod rewrite

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2 

RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# + ext lists
# bcmath bz2 calendar ctype dba dom enchant exif ffi fileinfo filter ftp gd gettext gmp
# hash iconv  intl  ldap mbstring oci8 odbc pcntl pdo pdo_dblib pdo_firebird
# pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline reflection
# shmop simplexml snmp   sodium spl
# standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader xmlrpc xmlwriter xsl zend_test | zip curl imap
 
RUN docker-php-ext-enable mysqli  session sockets  
# RUN apt-get install  -y  php-mbstring pdo_mysql
# DO NOT install php7.4-xdebug package for site running in production! It will slow it down significantly.
	
COPY ./conf/php/php.ini /etc/php/7.4/fpm/conf.d/90-php.ini
COPY ./conf/php/php.ini /etc/php/7.4/cli/conf.d/90-php.ini
COPY ./conf/php/php.ini /usr/local/etc/php/php.ini 
 
RUN > /var/log/php_error.log
RUN chmod 777 /var/log/php_error.log
RUN mkdir -p /var/lib/php/session
RUN chmod 777 /var/lib/php/session
RUN chown -R www-data:www-data /var/lib/php/session

# RUN chown -R root:root /var/www/html
# RUN find /var/www/html/ -type d -exec chmod 755 {} \; &&\
#     find /var/www/html/ -type f -exec chmod 664 {} \;

RUN sed -i '/#!\/bin\/sh/aservice sendmail restart' /usr/local/bin/docker-php-entrypoint
#RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost ${VIRTUAL_HOST}" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint  
 
 
#RUN pecl install && pecl install xdebug-2.8.1 && docker-php-ext-enable xdebug

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
 