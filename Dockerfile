FROM nginx
MAINTAINER Marc Richter <mr@in-telegence.net>

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get -yq install \
        curl \
	    procps \
	    php5-mcrypt \
	    php5-fpm \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc \
	    unzip \
	    vim \
	&& rm -rf /var/cache/apt /var/lib/apt/lists

# Configure php-fpm
RUN sed -i 's/^;\(error_log.*$\)/\1/g' /etc/php5/fpm/php-fpm.conf && \
	sed -i 's/^post_max_size.*$/post_max_size = 512M/g' /etc/php5/fpm/php.ini && \
	sed -i 's/^upload_max_filesize.*$/upload_max_filesize = 512M/g' /etc/php5/fpm/php.ini && \
	touch /var/log/php_errors.log && \
		chmod 777 /var/log/php_errors.log && \
		echo "" >> /etc/php5/fpm/php.ini && echo "error_log = /var/log/php_errors.log"

# Configure nginx
RUN rm -f /etc/nginx/conf.d/default.conf
ADD default.conf /etc/nginx/conf.d/default.conf
RUN sed -i 's/^listen.owner =.*$/listen.owner = nginx/g' /etc/php5/fpm/pool.d/www.conf && \
	sed -i 's/^listen.group =.*$/listen.group = nginx/g' /etc/php5/fpm/pool.d/www.conf && \
	sed -i 's/^;listen.mode =.*$/listen.mode = 0660/g' /etc/php5/fpm/pool.d/www.conf

# Enable mcrypt PHP module
RUN php5enmod mcrypt

# Download and extract PHPMyAdmin
RUN set -x \
    && mkdir -p /usr/share/nginx/html \
    && curl -Ls "https://phpmyadmin-downloads-532693.c.cdn77.org/phpMyAdmin/4.4.9/phpMyAdmin-4.4.9-all-languages.tar.bz2" \
    | tar -xj --directory /usr/share/nginx/html --strip-components=1 \
    && chown nginx -R /usr/share/nginx/html

# Add startup script to image
ADD config.inc.php /config.inc.php
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Generate random Blowfish-secret
RUN BFRAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)" \
    cat /config.inc.php | sed "s#BFSECRET#${BFRAND}#g" > /usr/share/nginx/html/config.inc.php

# Expose ports and define startup command
EXPOSE 80
CMD ["/run.sh"]
