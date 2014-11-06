#!/bin/bash
# Get latest PHPMyAdmin
curl -L http://sourceforge.net/projects/phpmyadmin/files/latest/download -o /tmp/pma-latest.zip && \
    unzip /tmp/pma-latest.zip -d /tmp && \
    rm -rf /usr/share/nginx/html /tmp/pma-latest.zip && \
    mv /tmp/phpMyAdmin-*-all-languages /usr/share/nginx/html && \
    chown nginx -R /usr/share/nginx/html

# Generate random Blowfish-secret
BFRAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
cat /config.inc.php | sed "s#BFSECRET#${BFRAND}#g" > /usr/share/nginx/html/config.inc.php
unset BFRAND

# Start daemons
php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf -g /var/run/php5-fpm.pid -D
nginx -c /etc/nginx/nginx.conf -g "daemon off;"

