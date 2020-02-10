FROM ocaml/opam2:alpine-3.9-opam
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all
ENV OPAMYES 1

RUN sudo apk update &&\
    sudo apk upgrade &&\
    sudo apk add m4 &&\
    sudo adduser -S docker &&\ 
    sudo touch /etc/sudoers.d/docker &&\
    sudo sh -c "echo 'docker ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker" &&\
    sudo chmod 440 /etc/sudoers.d/docker &&\
    sudo chown root:root /etc/sudoers.d/docker &&\
    sudo sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers

USER docker
WORKDIR "/home/docker"

# install git
RUN sudo apk add git

# install sphinx documentation generator and related packages
RUN sudo apk add python3 &&\
    sudo apk add py3-pip &&\
    sudo pip3 install --upgrade pip &&\
    sudo pip3 install sphinx==2.2.0

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


# switch to working directory within container
WORKDIR "/home/docker/uberspark/build-trusses"


CMD opam switch 4.09.0+flambda && \
    eval $(opam env) && \
    find  -type f  -exec touch {} + &&\
    ${D_CMD} ${D_CMDARGS}

# for debugging only
#ENTRYPOINT [ "/bin/bash"]
