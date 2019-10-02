FROM ocaml/opam2:alpine-3.9
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all

RUN sudo apk update 
RUN sudo apk upgrade
RUN sudo apk add m4
RUN sudo adduser -S docker 
RUN  sudo touch /etc/sudoers.d/docker
RUN sudo sh -c "echo 'docker ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker"
RUN sudo chmod 440 /etc/sudoers.d/docker
RUN  sudo chown root:root /etc/sudoers.d/docker
RUN  sudo sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers

USER docker
WORKDIR "/home/docker"

RUN opam init -a --disable-sandboxing && \
    eval $(opam env) && \
    opam install -y ocamlfind && \
    opam install -y yojson && \
    opam install -y cmdliner.1.0.4 && \
    opam install -y dune.1.11.3 && \
    opam install -y cppo.1.6.6 


# switch to working directory within container
WORKDIR "/home/docker/uberspark/build-trusses"


CMD opam switch default && \
    eval $(opam env) && \
    find  -type f  -exec touch {} + &&\
    ${D_CMD} ${D_CMDARGS}

# for debugging only
#ENTRYPOINT [ "/bin/bash"]
