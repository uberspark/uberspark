FROM amd64/ubuntu:16.04
LABEL author="Amit Vasudevan <amitvasudevan@acm.org>"

# update package repositories
RUN apt-get update

# setup default user
RUN apt-get -y install sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker
#RUN chown -R docker:docker /usr/lib/

# switch to working directory within container
RUN mkdir -p /home/docker/uberspark
WORKDIR "/home/docker/uberspark"

# install dependencies
RUN sudo apt-get -y install autoconf
RUN sudo apt-get -y install make
#RUN sudo apt-get -y install ocaml ocaml-findlib ocaml-native-compilers
RUN sudo apt-get -y install opam
RUN opam init && opam switch 4.02.3 && eval `opam config env`
RUN opam install yojson

# persist opam configuration when we run this container
# RUN echo "/home/docker/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> /home/docker/.profile

#COPY configure.ac /home/docker/.

#ENTRYPOINT /bin/bash

CMD ./bsconfigure.sh && \
    ./configure && \
    opam switch 4.02.3 && \
    eval `opam config env` && \
    sudo make OCAML_TOPLEVEL_PATH="${OCAML_TOPLEVEL_PATH}"
