FROM ocaml/opam2:alpine-3.9-opam
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all
ENV OPAMYES 1
ENV D_UID=1000
ENV D_GID=1000

# build time arguments
ARG GOSU_VERSION=1.10

######
# build commands
######

# drop to root
USER root

# update apk
RUN apk update &&\
    apk upgrade

# add shadow package to obtain usermod and groupmod commands
RUN apk add shadow

# add user uberspark, we will adjust uid and gid via entrypoint.sh
#RUN adduser -S uberspark &&\ 
#    touch /etc/sudoers.d/uberspark &&\
#    sh -c "echo 'uberspark ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/uberspark" &&\
#    chmod 440 /etc/sudoers.d/uberspark &&\
#    chown root:root /etc/sudoers.d/uberspark &&\
#    sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers

# add gosu
#RUN apk add vim && \
#    apk add wget && \
#    set -x && \
#    apk add --no-cache --virtual .gosu-deps dpkg gnupg openssl && \
#    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
#    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
#    chmod +x /usr/local/bin/gosu && \
#    gosu nobody true && \
#    apk del .gosu-deps

# setup entry point script that switches user uid/gid to match host
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# switch to working directory within container
WORKDIR "/home/uberspark/uberspark/build-trusses"

# invoke the entrypoint script which will adjust uid/gid and invoke d_cmd with d_cmdargs as user uberspark
CMD /docker-entrypoint.sh ${D_UID} ${D_GID} ${D_CMD} ${D_CMDARGS}

#CMD /bin/sh
# for debugging only
#ENTRYPOINT [ "/bin/bash"]
