FROM ubuntu:16.04
LABEL author="Amit Vasudevan <amitvasudevan@acm.org>"

# update package repositories
RUN apt-get update

# setup default user
RUN apt-get -y install sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker

# switch to working directory within container
RUN mkdir -p /home/docker/uberspark
WORKDIR "/home/docker/uberspark"

# install dependencies
RUN sudo apt-get -y install autoconf
RUN sudo apt-get -y install make
#RUN sudo apt-get -y install ocaml ocaml-findlib ocaml-native-compilers
RUN sudo apt-get -y install opam
RUN opam init && opam switch 4.07.0 && eval `opam config env`
RUN opam install yojson

# persist opam configuration when we run this container
# RUN echo "/home/docker/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> /home/docker/.profile

#COPY configure.ac /home/docker/.

ENTRYPOINT /bin/bash

#CMD /home/docker/bsconfigure.sh && \
#    /home/docker/configure && \
#    sudo make
