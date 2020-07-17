#!/bin/sh

# author: Amit Vasudevan <amitvasudevan@acm.org>

set -x

if [ "$(id -u)" = "0" ]; then
    uname=`id -u -n`
    echo "ROOT; username: $uname"
    echo "parameters: $@"

    # get uid to set
    echo "UID to set= $1"
  
    # get gid to set
    echo "GID to set= $2"

    # revise parameters by removing the uid and gid from command line
    shift 2

    echo "revised parameters: $@"


    # if they don't match, adjust
    #if [ ! -z "$SOCK_DOCKER_GID" -a "$SOCK_DOCKER_GID" != "$CUR_DOCKER_GID" ]; then
    #    groupmod -g ${SOCK_DOCKER_GID} -o docker
    #fi
    #if ! groups uberspark | grep -q docker; then
    #    usermod -aG docker uberspark
    #fi

    #gosu uberspark /docker-entrypoint.sh $@
    sudo -u uberspark /docker-entrypoint.sh $@
else
    uname=`id -u -n`
    echo "NON-ROOT; username: $uname"
    echo "parameters: $@"
    touch sample.txt
    #exec "$@"
fi


