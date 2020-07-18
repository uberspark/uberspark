#!/bin/sh

# author: Amit Vasudevan <amitvasudevan@acm.org>

set -x

if [ "$(id -u)" = "0" ]; then
    uname=`id -u -n`
    echo "ROOT; username: $uname"
    echo "parameters: $@"

    # get uid to set
    uid=$1
    echo "UID to set= $uid"
  
    # get gid to set
    gid=$2
    echo "GID to set= $gid"

    # revise parameters by removing the uid and gid from command line
    shift 2

    echo "revised parameters: $@"

    # create new user uberspark with group uberspark
    adduser -S uberspark 
 
    # creatr new group uberspark
    addgroup uberspark
 
    # change uberspark group gid to host GID
    groupmod -o -g $gid uberspark

    # change uberspark user uid to host UID
    usermod -o -u $uid -g $gid uberspark

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


