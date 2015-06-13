#!/bin/bash

# Start daemons
php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf -g /var/run/php5-fpm.pid -D
nginx -c /etc/nginx/nginx.conf -g "daemon off;"

