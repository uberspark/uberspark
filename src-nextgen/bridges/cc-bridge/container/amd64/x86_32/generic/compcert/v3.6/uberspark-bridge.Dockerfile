FROM ubuntu:18.04
MAINTAINER David Shepard <djshepard@sei.cmu.edu>

# Also pass in the name of the compiler archive file.

ENV archive_name=compcert-3.6.tgz

RUN apt-get update &&\
    apt-get -y install \
        wget \
        gcc-8 \
        gcc-8-multilib-arm-linux-gnueabihf \
        gcc-8-multilib-x86-64-linux-gnux32 \
        binutils \
        curl \
        rsync \
        git \
        make \
        m4 \
        patch \
        unzip \
        gawk \
        findutils \
        build-essential

# Put everything in the build context.
RUN wget http://compcert.inria.fr/release/${archive_name}

RUN mv compcert-3.6.tgz /tmp/CompCert-3.6.tgz
ENV archive_name=CompCert-3.6.tgz

COPY install.sh compiler_script.sh /tmp/

# This didn't work because Opam asks questions, lots of them. I have a
# custom install.sh that is in the build directory. We just call that instead.
# curl https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh -O &&\

RUN cd /tmp &&\
    chmod 755 install.sh &&\
    chmod 755 compiler_script.sh &&\
    ./install.sh &&\
    useradd -ms /bin/bash ubuntu

# I had added this, in an attempt to get Bubblewrap to work. It didn't.
# Disabled Opam's use of Bubblewrap, instead.
# sysctl kernel.unprivileged_userns_clone=1 &&\

# Opam is not very script-friendly software. It insists on being run as an
# unprivileged user, in a kernel-enforced sandbox, and it asks questions
# when you run it.

# Opam also has a lot of dependencies that are not documented on its install
# page, see above, everything after binutils.

USER ubuntu
WORKDIR /home/ubuntu

RUN opam init --disable-sandboxing &&\
    opam upgrade &&\
    opam switch create 4.05.0 &&\
    opam install conf-findutils &&\
    opam install conf-m4 &&\
    opam install conf-m4 &&\
    opam install ocamlfind=1.8.1 &&\
    opam install base-num &&\
    opam install num &&\
    opam install camlp5=7.11 &&\
    eval `opam env ` &&\
    opam install coq=8.7.0 &&\
    opam install ocaml-secondary-compiler=4.08.1 &&\
    opam install ocamlfind-secondary=1.8.1 &&\
    opam install dune &&\
    opam install ocamlbuild=0.14.0 &&\
    opam install menhir.20190626


# Build directions say you only need to run like four opam commands to get it
# installed. If you don't want opam to ask you a lot of questions in your
# script, since they don't respect any form of auto-answer I could think of
# running, you need to run thirteen opam commands.

# Now that opam is installed, we can go about building our compiler, which
# requires us to be root again.

USER root
WORKDIR /tmp
RUN echo $archive_name

RUN tar -xzf ${archive_name}

# Apparently, the following is a "bash-ism". I.e., this only works in bash. To make it
# work in Dash, Ubuntu's default shell for /bin/sh, the bin that is called when
# Docker builds, you need to do substring parsing with an awk script. That's
# done in compiler_script.sh

#RUN archive_dir=${archive_name:0:$archive_string_len-4}

RUN . ./compiler_script.sh

WORKDIR /home

