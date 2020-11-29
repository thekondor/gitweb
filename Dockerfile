FROM nginx:1.19
LABEL maintainer "github.com/thekondor"
LABEL original_maintainer "fraoustin@gmail.com"

COPY ./src/default.conf /etc/nginx/conf.d/default.conf
COPY ./src/fastcgi.conf /etc/nginx/conf.d/fastcgi.conf

COPY ./src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV SET_CONTAINER_TIMEZONE false 
ENV CONTAINER_TIMEZONE "" 
ENV ALLOW_RO_ACCESS ""

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        fcgiwrap \
        git \
        git-core \
        gitweb \
        highlight \
        libcgi-pm-perl \
        mime-support \
        spawn-fcgi \
    && rm -rf /var/lib/apt/lists/* 

# manage user load fcgiwrap
RUN sed -i "s/www-data/nginx/g" /etc/init.d/fcgiwrap

# manage start container
RUN mkdir /usr/share/gitweb/docker-entrypoint.pre
RUN mkdir /usr/share/gitweb/docker-entrypoint.post
COPY ./src/00_user_ids.sh /usr/share/gitweb/docker-entrypoint.pre/00_user_ids.sh
COPY ./src/01_git_projects.sh /usr/share/gitweb/docker-entrypoint.pre/01_git_projects.sh
COPY ./src/02_auth.sh /usr/share/gitweb/docker-entrypoint.pre/02_auth.sh
RUN chmod +x -R /usr/share/gitweb/docker-entrypoint.pre

# add cmd gitweb
COPY ./src/cmd/addrepos.sh /usr/bin/addrepos
COPY ./src/cmd/rmrepos.sh /usr/bin/rmrepos
RUN chmod +x /usr/bin/addrepos
RUN chmod +x /usr/bin/rmrepos

# add ihm mdl
ENV IHM no-mdl
COPY ./src/ihm /mdl-ihm
RUN cp /usr/share/gitweb/static/gitweb.css /usr/share/gitweb/static/gitweb.css.original
RUN mkdir /usr/share/gitweb/ihm

VOLUME /var/lib/git
VOLUME /etc/nginx/.htpasswd
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["app"]
