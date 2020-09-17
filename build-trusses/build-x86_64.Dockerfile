FROM amd64/ubuntu:20.04 AS base
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"

# build time arguments
ARG GOSU_VERSION=1.10
ENV DEBIAN_FRONTEND=noninteractive
ENV OPAMYES 1

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all
ENV D_UID=1000
ENV D_GID=1000

######
# build commands
######

# drop to root
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

# install general development tools
RUN apt-get install -y git &&\
    apt-get install -y build-essential &&\
    apt-get install -y cmake &&\
    apt-get install -y flex &&\
    apt-get install -y bison &&\
    apt-get install -y opam &&\
    apt-get install -y python3 &&\
    apt-get install -y python3-pip 

# upgrade python installer, install python packages 
# related to documentation: sphinx, sphinx extensions, and breathe
RUN pip3 install --upgrade pip &&\
    pip3 install sphinx-jsondomain==0.0.3 &&\
    pip3 install -U sphinx==3.0.3 &&\
    pip3 install breathe==4.18.1

# install doxygen
WORKDIR "/home/uberspark"
RUN wget -O doxygen-Release_1_8_20.tar.gz https://github.com/doxygen/doxygen/archive/Release_1_8_20.tar.gz && \
    tar -xzf ./doxygen-Release_1_8_20.tar.gz   && \
    cd doxygen-Release_1_8_20 && \
    mkdir build && cd build && \
    cmake -G "Unix Makefiles" .. &&\
    make &&\
    make install && cd ../.. && \
    rm -rf doxygen-Release_1_8_20.tar.gz 


# switch user to uberspark working directory to /home/uberspark
USER uberspark
WORKDIR "/home/uberspark"


# install ocaml compiler
RUN opam init -a --comp=4.09.0+flambda --disable-sandboxing 

RUN eval $(opam env) && \
    opam install -y depext &&\
    opam depext -y ocamlfind &&\
    opam install -y ocamlfind &&\
    opam depext -y yojson &&\
    opam install -y yojson && \
    opam depext -y cmdliner.1.0.4 && \
    opam install -y cmdliner.1.0.4 && \
    opam depext -y astring.0.8.3 && \
    opam install -y astring.0.8.3 && \
    opam depext -y dune.1.11.3 && \
    opam install -y dune.1.11.3 && \
    opam depext -y cppo.1.6.6 && \
    opam install -y cppo.1.6.6 && \
    opam depext -y fileutils.0.6.1 &&\
    opam install -y fileutils.0.6.1 &&\
    opam depext -y frama-c.20.0 &&\
    opam install -y frama-c.20.0

# drop back to root
USER root

# change permissions of /home/uberspark so everyone can access it
WORKDIR "/home/uberspark"
RUN chmod ugo+rwx -R .

# setup entry point script that switches user uid/gid to match host
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# switch to working directory within container
WORKDIR "/home/uberspark/uberspark/build-trusses"

# invoke the entrypoint script which will adjust uid/gid and invoke d_cmd with d_cmdargs as user uberspark
CMD /docker-entrypoint.sh ${D_UID} ${D_GID} ${D_CMD} ${D_CMDARGS}



