#!/bin/bash
PMACONFIG="/usr/share/nginx/html/config.inc.php"

# Generate random Blowfish-secret
export BFRAND="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)" \
  && sed -i'' "s#\$cfg\[.*'blowfish_secret'.*\].*=.*'.*'.*\;.*\$#\$cfg[\'blowfish_secret\'] = "\'${BFRAND}\'";#g" \
    ${PMACONFIG} \
  && unset BFRAND

# Set PmaAbsoluteUri if Env var PMAABSOLUTEURI is set
if [ ! -z "${PMAABSOLUTEURI}" ]; then
    sed -i'' "s#^;\(.*PmaAbsoluteUri.*=\).*\$#\1 \'${PMAABSOLUTEURI}\';#g" ${PMACONFIG}
else
    sed -i'' 's#^\(\$.*PmaAbsoluteUri.*$\)#;\1#g' ${PMACONFIG}
fi

# Start daemons
php5-fpm --fpm-config /etc/php5/fpm/php-fpm.conf -g /var/run/php5-fpm.pid -D
nginx -c /etc/nginx/nginx.conf -g "daemon off;"

