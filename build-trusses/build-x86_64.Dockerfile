FROM amd64/ubuntu:18.04
LABEL author="Amit Vasudevan <amitvasudevan@acm.org>"

# runtime arguments
ENV MAKE_COMMAND make
ENV MAKE_TARGET all


# update package repositories
RUN apt-get update && \
    # setup default user 
    apt-get -y install apt-utils &&\
    apt-get -y install sudo && \
    adduser --disabled-password --gecos '' docker && \
    adduser docker sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# install dependencies
RUN apt-get update && \
    sudo apt-get -y install software-properties-common && \
    sudo apt-get -y install autoconf && \
    sudo apt-get -y install make && \
    sudo apt-get -y install wget && \
    sudo apt-get -y install patch && \
    sudo apt-get -y install unzip && \
    sudo apt-get -y install gcc binutils &&\
    sudo apt-get -y install bubblewrap 

# documentation dependencies
RUN export DEBIAN_FRONTEND=noninteractive &&\
    sudo apt-get update &&\
    sudo -E apt-get -y install texlive-latex-recommended &&\
    sudo -E apt-get -y install texlive-fonts-recommended &&\
    sudo -E apt-get -y install texlive-latex-extra &&\
    sudo -E apt-get -y install latexmk &&\
    sudo -E apt-get -y install python3-sphinx 


USER docker
WORKDIR "/home/docker"

RUN sudo chmod u+s /usr/bin/bwrap
RUN wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
RUN sudo chmod +x /home/docker/install.sh
RUN printf "/usr/local/bin\n" | sudo /home/docker/install.sh
RUN opam init -a --disable-sandboxing
RUN sudo apt-get -y install musl-tools
RUN eval $(opam env)
RUN opam switch install 4.08.1+musl+static+flambda
RUN opam switch 4.08.1+musl+static+flambda
RUN eval $(opam env)
RUN opam install -y ocamlfind
RUN opam install -y yojson
RUN opam install -y cmdliner.1.0.4 
RUN opam install -y dune.1.11.3
RUN opam install -y cppo.1.6.6


# switch to working directory within container
WORKDIR "/home/docker/uberspark/build-trusses"

#    chmod +x ./bsconfigure.sh && \
#    ./bsconfigure.sh && \
#    ./configure && \

CMD opam switch 4.08.1+musl+static+flambda && \
    eval $(opam env) && \
    find  -type f  -exec touch {} + &&\
    ${MAKE_COMMAND} ${MAKE_TARGET}

# for debugging only
#ENTRYPOINT [ "/bin/bash"]