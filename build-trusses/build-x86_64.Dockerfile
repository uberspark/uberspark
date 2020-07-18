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

# setup entry point script that switches user uid/gid to match host
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# switch to working directory within container
WORKDIR "/home/uberspark/uberspark/build-trusses"

# invoke the entrypoint script which will adjust uid/gid and invoke d_cmd with d_cmdargs as user uberspark
CMD /docker-entrypoint.sh ${D_UID} ${D_GID} ${D_CMD} ${D_CMDARGS}

