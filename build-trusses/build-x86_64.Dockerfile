#FROM ocaml/opam2:alpine-3.9-opam
FROM amd64/ubuntu:20.04 AS base
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"

ENV DEBIAN_FRONTEND=noninteractive

#MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

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
#RUN apk update &&\
#    apk upgrade

# remove default opam user from image so we don't conflict on uid-->username mappings
#RUN deluser opam

# update apt packages and install sudo
RUN apt-get update -y &&\
    apt-get install -y --no-install-recommends apt-utils &&\
    apt-get install -y sudo


# create user uberspark and group uberspark so we have access to /home/uberspark
RUN addgroup --system uberspark &&\
    adduser --system --disabled-password --ingroup uberspark uberspark &&\
    usermod -aG sudo uberspark &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# switch user to uberspark working directory to /home/uberspark
USER uberspark
WORKDIR "/home/uberspark"

# install general development tools
#RUN sudo apt-get install -y git &&\
#    sudo apt-get install -y build-essential &&\
#    sudo apt-get install -y cmake &&\
#    sudo apt-get install -y flex &&\
#    sudo apt-get install -y bison &&\
#    sudo apt-get install -y opam

# install python 3
#RUN apt-get install -y python3 &&\
#    apt-get install -y python3-pip 

#RUN pip3 install --upgrade pip

# install sphinx documentation extensions
#RUN pip3 install sphinx-jsondomain==0.0.3

# install sphinx documentation generator
#RUN pip3 install -U sphinx==3.0.3

# install breathe
#RUN pip3 install breathe==4.18.1

# install doxygen
#WORKDIR "/home/uberspark"
#RUN wget -O doxygen-Release_1_8_20.tar.gz https://github.com/doxygen/doxygen/archive/Release_1_8_20.tar.gz && \
#    tar -xzf ./doxygen-Release_1_8_20.tar.gz   && \
#    cd doxygen-Release_1_8_20 && \
#    mkdir build && cd build && \
#    cmake -G "Unix Makefiles" .. &&\
#    make &&\
#    make install && cd ../.. && \
#    rm -rf doxygen-Release_1_8_20.tar.gz 


# install ocaml compiler
#RUN opam init -a --comp=4.09.0+flambda --disable-sandboxing 

#RUN eval $(opam env) && \
#    opam install -y depext &&\
#    opam depext -y ocamlfind &&\
#    opam install -y ocamlfind &&\
#    opam depext -y yojson &&\
#    opam install -y yojson && \
#    opam depext -y cmdliner.1.0.4 && \
#    opam install -y cmdliner.1.0.4 && \
#    opam depext -y astring.0.8.3 && \
#    opam install -y astring.0.8.3 && \
#    opam depext -y dune.1.11.3 && \
#    opam install -y dune.1.11.3 && \
#    opam depext -y cppo.1.6.6 && \
#    opam install -y cppo.1.6.6 && \
#    opam depext -y fileutils.0.6.1 &&\
#    opam install -y fileutils.0.6.1 &&\
#    opam depext -y frama-c.20.0 &&\
#    opam install -y frama-c.20.0

# drop back to root
#USER root

# change permissions of /home/uberspark so everyone can access it
#WORKDIR "/home/uberspark"
#RUN chmod ugo+rwx -R .


