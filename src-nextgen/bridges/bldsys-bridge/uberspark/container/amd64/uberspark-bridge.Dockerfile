##############################################################################
#
# uberSpark bridge docker container template
#
##############################################################################

##############################################################################
# basic distro and maintainer -- CUSTOMIZABLE
##############################################################################

FROM ocaml/opam2:alpine-3.9-opam
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"


##############################################################################
# required boilerplate commands below -- DO NOT CHANGE
##############################################################################

ENV D_CMD=/bin/bash
ENV D_UID=1000
ENV D_GID=1000

# drop to root
USER root

# update apk and install package shadow for sudo
RUN apk update &&\
    apk upgrade &&\
    apk add shadow

# create user uberspark and group uberspark so we have access to /home/uberspark
RUN addgroup -S uberspark &&\
    adduser -S uberspark -G uberspark


##############################################################################
# bridge specific installation commands -- CUSTOMIZABLE
# note: must remove any pre-defined user the FROM image may come
# with so that we don't conflict on uid/gid mappings. i.e., the
# container should only contain users root and uberspark 
##############################################################################

# remove default opam user from image so we don't conflict on uid-->username mappings
RUN deluser opam

# install general development tools
RUN apk add m4 &&\
    apk add git &&\
    apk add cmake &&\
    apk add flex &&\
    apk add bison 

# install python 3
RUN apk add python3 &&\
    apk add py3-pip &&\
    pip3 install --upgrade pip

# install sphinx documentation extensions
RUN pip3 install sphinx-jsondomain==0.0.3

# install sphinx documentation generator
RUN pip3 install -U sphinx==3.0.3

# install breathe
RUN pip3 install breathe==4.18.1

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

# install ocaml compiler and related packages
RUN opam init -a --comp=4.09.0+flambda --disable-sandboxing && \
    eval $(opam env) && \
    opam install -y depext &&\
    opam install -y depext &&\
    opam install -y ocamlfind && \
    opam install -y yojson && \
    opam install -y cmdliner.1.0.4 && \
    opam install -y astring.0.8.3 && \
    opam install -y dune.1.11.3 && \
    opam install -y cppo.1.6.6 && \
    opam install -y fileutils.0.6.1 



##############################################################################
# entry point and permissions biolerplate -- DO NOT CHANGE
##############################################################################

# drop back to root
USER root

# change permissions of /home/uberspark so everyone can access it
WORKDIR "/home/uberspark"
RUN chmod ugo+rwx -R .

# setup entry point script that switches user uid/gid to match host
COPY common/container/amd64/docker-entrypoint-alpine.sh /docker-entrypoint-alpine.sh
RUN chmod +x /docker-entrypoint-alpine.sh

# invoke the entrypoint script which will adjust uid/gid and invoke d_cmd with d_cmdargs as user uberspark
CMD /docker-entrypoint-alpine.sh ${D_UID} ${D_GID} ${D_CMD}
