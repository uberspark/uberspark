##############################################################################
#
# uberSpark bridge docker container template -- alpine distribution
#
##############################################################################

##############################################################################
# basic distro and maintainer -- CUSTOMIZABLE
##############################################################################

FROM amd64/ubuntu:16.04
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"


##############################################################################
# required boilerplate commands below -- DO NOT CHANGE
##############################################################################

ENV DEBIAN_FRONTEND=noninteractive

# runtime arguments
ENV D_CMD=/bin/bash
ENV D_UID=1000
ENV D_GID=1000

# switch to root
USER root

# update apt packages, install sudo, and select non-interactive mode
RUN apt-get update -y &&\
    apt-get install -y --no-install-recommends apt-utils &&\
    apt-get install -y sudo &&\
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# create user uberspark and group uberspark so we have access to /home/uberspark
RUN addgroup --system uberspark &&\
    adduser --system --disabled-password --ingroup uberspark uberspark &&\
    usermod -aG sudo uberspark &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

##############################################################################
# bridge specific installation commands -- CUSTOMIZABLE
# note: must remove any pre-defined user the FROM image may come
# with so that we don't conflict on uid/gid mappings. i.e., the
# container should only contain users root and uberspark 
##############################################################################

RUN apt-get update &&\
    apt-get -y install gcc gcc-multilib binutils



##############################################################################
# entry point and permissions biolerplate -- DO NOT CHANGE
##############################################################################

# drop back to root
USER root

# change permissions of /home/uberspark so everyone can access it
WORKDIR "/home/uberspark"
RUN chmod ugo+rwx -R .

# setup entry point script that switches user uid/gid to match host
COPY common/container/amd64/docker-entrypoint-ubuntu.sh /docker-entrypoint-ubuntu.sh
RUN chmod +x /docker-entrypoint-ubuntu.sh

# invoke the entrypoint script which will adjust uid/gid and invoke d_cmd with d_cmdargs as user uberspark
CMD /docker-entrypoint-ubuntu.sh ${D_UID} ${D_GID} ${D_CMD}

