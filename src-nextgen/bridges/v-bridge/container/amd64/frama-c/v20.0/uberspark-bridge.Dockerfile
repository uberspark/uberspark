FROM amd64/ubuntu:19.10 AS base
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>" author="Amit Vasudevan <amitvasudevan@acm.org>"


USER root
WORKDIR /build

RUN apt-get update -y \
 && apt-get install -y \
    git \
    ocaml \
    ocaml-native-compilers \
    liblablgtk2-ocaml-dev \
    liblablgtksourceview2-ocaml-dev \
    libocamlgraph-ocaml-dev \
    menhir \
    why3 \
    libyojson-ocaml-dev \
    libocamlgraph-ocaml-dev \
    libzarith-ocaml-dev \
    build-essential \
 && rm -rf /var/lib/apt/lists/* \
 && git clone --single-branch https://github.com/Frama-C/Frama-C-snapshot.git . \
 && git checkout -b tags/20.0 \
 && ./configure \
 && make \
 && make install

FROM amd64/ubuntu:19.10

COPY --from=base /usr/local/ /usr/local/

RUN apt-get update -y \
 && apt-get install -y \
    libfindlib-ocaml \
    libocamlgraph-ocaml-dev \
    libzarith-ocaml \
    libyojson-ocaml-dev \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -r frama-c \
 && useradd --no-log-init -r -g frama-c frama-c

USER frama-c
WORKDIR /src
#ENTRYPOINT ["frama-c"]

