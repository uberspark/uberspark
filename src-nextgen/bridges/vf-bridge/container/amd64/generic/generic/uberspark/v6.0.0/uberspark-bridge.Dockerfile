##############################################################################
#
# uberSpark bridge docker container template
#
##############################################################################

##############################################################################
# basic distro and maintainer -- CUSTOMIZABLE
##############################################################################

FROM amd64/ubuntu:20.04 AS base
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

# see https://www.lri.fr/~marche/MPRI-2-36-1/install.html on how to install provers

# install base system packages
RUN apt-get update -y && \
    apt-get install -y \
        git \
        build-essential \
        opam

WORKDIR "/home/uberspark"

# install CVC4 prover
RUN wget https://github.com/CVC4/CVC4/releases/download/1.8/cvc4-1.8-x86_64-linux-opt
RUN cp ./cvc4-1.8-x86_64-linux-opt /usr/local/bin/cvc4
RUN chmod +x /usr/local/bin/cvc4
RUN cvc4 --version

# install Z3 prover
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip
RUN unzip z3-4.8.9-x64-ubuntu-16.04.zip
RUN cp z3-4.8.9-x64-ubuntu-16.04/bin/z3 /usr/local/bin
RUN chmod +x /usr/local/bin/z3
RUN z3 -version


# switch user to uberspark working directory to /home/uberspark
USER uberspark
WORKDIR "/home/uberspark"


# install ocaml compiler and related packages
RUN opam init -a --comp=4.09.0+flambda --disable-sandboxing && \
    eval $(opam env) && \
    opam install -y depext &&\
    opam depext -y why3 &&\
    opam install -y why3 &&\
    opam depext -y alt-ergo &&\
    opam install -y alt-ergo &&\
    opam depext -y frama-c.20.0 &&\
    opam install -y frama-c.20.0 

# install packages required by uberspark lib
RUN eval $(opam env) && \
    opam depext -y fileutils.0.6.1 &&\
    opam install -y fileutils.0.6.1 


# update why3 with installed provers
RUN eval $(opam env) && \
    why3 config --detect && \
    why3 --list-provers




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

