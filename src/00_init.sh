#!/bin/bash

for GITPROJECT in $(echo "${GITPROJECTS}" | tr , '\n'); do
    REPOS="/var/lib/git/${GITPROJECT}.git"
    if [ -d "${REPOS}" ]; then
        continue
    fi

    addrepos $GITPROJECT
    cd $REPOS
    chmod -R g+ws .
    chgrp -R nginx .
done

if [ ! -z "$GITUSER" ]; then
    addauth $GITUSER $GITPASSWORD
fi 
