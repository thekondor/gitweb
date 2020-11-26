#!/bin/bash

if [ -n "${UID_REMAP}" ]; then
    # TODO: check for container's UID existence
    usermod -u ${UID_REMAP} nginx
fi

if [ -n "${GID_REMAP}" ]; then
    getent group ${GID_REMAP} || addgroup --gid ${GID_REMAP} group_${GID_REMAP}_from_host
    usermod -g ${GID_REMAP} nginx
fi
