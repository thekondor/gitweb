#!/bin/bash

if [ ! -z "$GITUSER" ]; then
    addauth $GITUSER $GITPASSWORD
fi
