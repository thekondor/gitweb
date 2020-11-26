#!/bin/bash

if [ -f "${_BASE_HTPASSWD}" ]; then
    cp ${_BASE_HTPASSWD} ${_HTPASSWD}
fi

if [ -n "$GITUSER" -a ! -e ${_HTPASSWD} ]; then
    addauth $GITUSER $GITPASSWORD
fi
