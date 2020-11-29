#!/bin/bash

_NGINX_CONF=/etc/nginx/conf.d/default.conf

if [ -n "${ALLOW_RO_ACCESS}" ]; then
    echo "- IMPORTANT: Authenication for gitweb/pull is disabled!"
    sed -e '/#-BEGIN_PROTECTED_ACCESS-#/,/#-END_PROTECTED_ACCESS-#/d' -i /etc/nginx/conf.d/default.conf
fi
