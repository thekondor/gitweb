> This fork contain small improvements to handle some specific cases (and making them universal) not covered by the original implementation. Basically:
> - Multiple git projects `vs` single one
> - Host user's ID & GID mapping to a container `vs` default `nginx`'s ones
> - Mount of host's `.htpasswd` `vs` managing internal one

> All credits for this Dockerfile go to [fraoustin/gitweb](https://github.com/fraoustin/gitweb)

# Docker Image for gitweb

generate a nginx server with git server and gitweb for ihm on http://127.0.0.1/

load when start image load file in

- /usr/share/gitweb/docker-entrypoint.pre
- /usr/share/gitweb/docker-entrypoint.post

## Parameter

- `SET_CONTAINER_TIMEZONE` (false or true) manage time of container
- `CONTAINER_TIMEZONE` timezone of container
- `GITPROJECTS` (list of projects separated with `,`)
- `GITUSER` (default: `gituser`)
- `GITPASSWORD` (default: `gitpassword`)
- `IHM` (default: `""`)
- `UID_REMAP` (default: `""`): to set `nginx`'s UID
- `GID_REMAP` (default: `""`): to set `nginx`'s primary GID

**NOTE**: `GITUSER` & `GITPASSWORD` are not taken into account when `/etc/nginx/htpasswd.base` volume is mounted. They should be added explicitly then.

## Volume

- /var/lib/git
- /etc/nginx/htpasswd.base

**NOTE**: by default all r/w access to contents of repositories inside the volume is made by `nginx:nginx` user. When the volume is mounted externally, that makes sense to make `nginx`'s user to reflects runner's ID and GID from the host. Otherwise access issues is thing to deal with.

Basically: `docker run [...] -e UID_REMAP=$(id -u) -e GID_REMAP=$(id -g) [...]`

## Port

- 80 for gitweb

## Command

- addrepos: add repository
- addauth : add user for git
- rmrepos : remove repository
- rmauth : remove user

**NOTE**: keep in mind `htpasswd.base`'s ACL once it is mounted as a volume.

## Usage direct

run image fraoustin/gitweb

    docker run -d -e "CONTAINER_TIMEZONE=Europe/Paris" -e "GITPROJECTS=test-foo,test-bar" -v <localpath>:/var/lib/git --name test -p 80:80 fraoustin/gitweb

user default is gituser and password default is gitpassword

you use http://localhost/ for access gitweb

you can clone project

    git clone http://gituser:gitpassword@localhost/test.git

You can change user and password by variable environment


## Usage by Dockerfile

Sample of Dockerfile

    FROM fraoustin/gitweb
    COPY ./00_init.sh /usr/share/gitweb/docker-entrypoint.pre/00_init.sh
    RUN chmod +x -R /usr/share/gitweb/docker-entrypoint.pre

File 00_init.sh

    #!/bin/bash
    REPOS='/var/lib/git/test.git'
    if [ ! -d $REPOS ]; then
        addrepos test
        cd $REPOS
        chmod -R g+ws .
        chgrp -R nginx .
    fi
    addauth $GITUSER $GITPASSWORD

build image mygit

    docker build -t mygit .

run image mygit

    docker run -d -e "CONTAINER_TIMEZONE=Europe/Paris" -e "GITUSER=gituser" -e "GITPASSWORD=gitpassword" -v <localpath>:/var/lib/git --name test -p 80:80 mygit




## IHM material design

If you want use a new design for ihm, you can use IHM variable

- IHM = mdl

    ```sh
    docker run -d -e "CONTAINER_TIMEZONE=Europe/Paris" -e "IHM=mdl" -e "GITPROJECTS=test" -v <localpath>:/var/lib/git --name test -p 80:80 fraoustin/gitweb
    ```

