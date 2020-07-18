#!/bin/sh

# author: Amit Vasudevan <amitvasudevan@acm.org>

set -x

# if we are running as root then drop to user uberspark
if [ "$(id -u)" = "0" ]; then
    #grab host uid and gid passed to us via command line parameters
    uid=$1
    gid=$2

    #debug
        #uname=`id -u -n`
        #echo "ROOT; username: $uname"
        #echo "parameters: $@"
        #echo "UID to set= $uid"
        #echo "GID to set= $gid"

    # revise parameters by removing the uid and gid from command line
    shift 2

    #debug
        #echo "revised parameters: $@"

    # create new user uberspark with group uberspark
    adduser -S uberspark 
 
    # creatr new group uberspark
    addgroup uberspark
 
    # change uberspark group gid to host GID
    groupmod -o -g $gid uberspark

    # change uberspark user uid to host UID
    usermod -o -u $uid -g $gid uberspark

    # drop to user uberspark and execute this script with the remaining parameters
    sudo -u uberspark /docker-entrypoint.sh $@

else
    # now we are run as user uberspark, so execute the command
    #debug
        #uname=`id -u -n`
        #echo "NON-ROOT; username: $uname"
        #echo "parameters: $@"

    # execute the command and actual parameters as user uberspark
    exec "$@"
fi


