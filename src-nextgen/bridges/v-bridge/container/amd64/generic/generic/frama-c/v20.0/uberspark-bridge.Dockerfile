#FROM amd64/ubuntu:19.10 AS base
FROM amd64/ubuntu:20.04 AS base
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"

ENV DEBIAN_FRONTEND=noninteractive

#USER root
#WORKDIR /build

#RUN apt-get update -y \
# && apt-get install -y \
#    git \
#    ocaml \
#    ocaml-native-compilers \
#    liblablgtk2-ocaml-dev \
#    liblablgtksourceview2-ocaml-dev \
#    libocamlgraph-ocaml-dev \
#    menhir \
#    why3 \
#    libyojson-ocaml-dev \
#    libocamlgraph-ocaml-dev \
#    libzarith-ocaml-dev \
#    build-essential \
# && rm -rf /var/lib/apt/lists/* \
# && git clone --single-branch https://github.com/Frama-C/Frama-C-snapshot.git . \
# && git checkout -b tags/20.0 \
# && ./configure \
# && make \
# && make install

#FROM amd64/ubuntu:19.10

#COPY --from=base /usr/local/ /usr/local/

#RUN apt-get update -y \
# && apt-get install -y \
#    pkg-config\
#    libfindlib-ocaml \
#    libocamlgraph-ocaml-dev \
#    libzarith-ocaml \
#    libyojson-ocaml-dev \
#    opam \
# && rm -rf /var/lib/apt/lists/* 

# \
# && groupadd -r frama-c \
# && useradd --no-log-init -r -g frama-c frama-c

#USER frama-c
#WORKDIR /src


# see https://www.lri.fr/~marche/MPRI-2-36-1/install.html on how to install provers

USER root
WORKDIR /root/build

RUN apt-get update -y && \
    apt-get install -y \
        git \
        build-essential \
        opam

# install ocaml compiler and related packages
RUN opam init -a --comp=4.09.0+flambda --disable-sandboxing && \
    eval $(opam env) && \
    opam install -y depext &&\
    opam depext -y why3 &&\
    opam install -y why3 &&\
    opam depext -y alt-ergo &&\
    opam install -y alt-ergo &&\
    opam depext -y frama-c.20.0 &&\
    opam install -y frama-c.20.0 

# install CVC4 prover
RUN wget https://github.com/CVC4/CVC4/releases/download/1.8/cvc4-1.8-x86_64-linux-opt
RUN cp ./cvc4-1.8-x86_64-linux-opt /usr/local/bin/cvc4
RUN chmod +x /usr/local/bin/cvc4
RUN cvc4 --version

# install Z3 prover
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.9/z3-4.8.9-x64-ubuntu-16.04.zip
RUN unzip z3-4.8.9-x64-ubuntu-16.04.zip
RUN cp z3-4.8.9-x64-ubuntu-16.04/bin/z3 /usr/local/bin
RUN chmod +x /usr/local/bin/z3
RUN z3 -version

# update why3 with installed provers
RUN eval $(opam env) && \
    why3 config --detect && \
    why3 --list-provers
