FROM amd64/ubuntu:18.04
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

WORKDIR "/home/docker"


# install dependencies
RUN sudo apt-get -y install software-properties-common
RUN sudo apt-get -y install autoconf
RUN sudo apt-get -y install make
RUN sudo apt-get -y install wget
RUN sudo apt-get -y install patch
RUN sudo apt-get -y install unzip
RUN sudo apt-get -y install gcc binutils
RUN sudo apt-get -y install bubblewrap
#RUN sudo add-apt-repository -y -u ppa:ansible/bubblewrap
#RUN sudo apt-get update

RUN sudo chmod u+s /usr/bin/bwrap
RUN wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
RUN sudo chmod +x /home/docker/install.sh
RUN printf "/usr/local/bin\n" | sudo /home/docker/install.sh
RUN printf "y" | opam init
RUN eval $(opam env)
RUN opam install -y ocamlfind
RUN opam install -y yojson
#RUN opam init && opam switch 4.02.3 && eval `opam config env`
#RUN opam install yojson

# persist opam configuration when we run this container
# RUN echo "/home/docker/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> /home/docker/.profile

#COPY configure.ac /home/docker/.

# switch to working directory within container
#RUN mkdir -p /home/docker/uberspark
#WORKDIR "/home/docker/uberspark"

ENTRYPOINT /bin/bash

#CMD ./bsconfigure.sh && \
#    ./configure && \
#    opam switch 4.02.3 && \
#    eval `opam config env` && \
#    sudo make OCAML_TOPLEVEL_PATH="${OCAML_TOPLEVEL_PATH}"
