#!/bin/bash
# Generate random Blowfish-secret
export BFRAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)" \
  && sed -i'' "s#\$cfg\[.*'blowfish_secret'.*\].*=.*'.*'.*\;.*\$#\$cfg[\'blowfish_secret\'] = "\'${BFRAND}\'";#g" \
    /usr/share/nginx/html/config.inc.php \
  && unset BFRAND

## Set PmaAbsoluteUri if Env var PMAABSOLUTEURI is set
#if [ ! -z "${PMAABSOLUTEURI}" ]; then
#    sed -i''
#fi

# Start daemons
php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf -g /var/run/php5-fpm.pid -D
nginx -c /etc/nginx/nginx.conf -g "daemon off;"

