FROM ocaml/opam2:ubuntu-16.04
LABEL maintainer "Josh Schlichting <schlichj11@gmail.com>"

ENV MENHIR_VER=20170712 \
    COMPCERT_VER=3.1 \
    FRAMA_C_VER=Phosphorus-20170501 \
    CVC3_VER=2.4.1-optimized-static \
    Z3_VER=4.4.1-x64-ubuntu-14.04
    
RUN sudo apt-get update && \
    sudo apt-get install -y m4 libgmp-dev \
    	 	 	    wget autoconf make \
			    libgtksourceview2.0-dev && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* && \
    mkdir run

# Setup OCaml environment
RUN opam init && opam switch 4.02 && opam update && \
    eval `opam config env` && opam install -j 2 coq=8.6.1 && \
    opam install menhir=${MENHIR_VER} depext zarith && \
    opam depext menhir=${MENHIR_VER} depext zarith camlzip && \
    opam install alt-ergo && opam install -j 2 why3.0.87.3 && \
    opam install yojson && eval `opam config env`
    
WORKDIR run

# CompCert
RUN wget http://compcert.inria.fr/release/compcert-${COMPCERT_VER}.tgz && \
    tar -xvzf compcert-${COMPCERT_VER}.tgz && \
    opam switch 4.02 && eval `opam config env` && \
    cd CompCert-${COMPCERT_VER} && ./configure x86_32-linux && \
    make all && sudo make install && cd .. && \
    rm compcert-${COMPCERT_VER}.tgz && rm -rf CompCert-${COMPCERT_VER}

# Frama-C
RUN wget http://frama-c.com/download/frama-c-${FRAMA_C_VER}.tar.gz && \
    tar -xvzf frama-c-${FRAMA_C_VER}.tar.gz && \
    opam switch 4.02 && eval `opam config env` && \
    cd frama-c-${FRAMA_C_VER} && ./configure && \
    make && sudo make install && cd .. && \
    rm frama-c-${FRAMA_C_VER}.tar.gz && \
    rm -rf frama-c-${FRAMA_C_VER}

# CVC3
RUN wget http://www.cs.nyu.edu/acsys/cvc3/releases/2.4.1/linux64/cvc3-${CVC3_VER}.tar.gz && \
    tar -xzf cvc3-${CVC3_VER}.tar.gz && \
    sudo cp -R cvc3-${CVC3_VER}/* /usr/local/ && \
    rm cvc3-${CVC3_VER}.tar.gz && \
    rm -rf cvc3-${CVC3_VER}

# Z3
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.4.1/z3-${Z3_VER}.zip && \
    unzip z3-${Z3_VER}.zip && \
    sudo cp z3-${Z3_VER}/bin/z3 /usr/local/bin && \
    rm z3-${Z3_VER}.zip && \
    rm -rf z3-${Z3_VER}

# uberspark tools and libraries
RUN git clone https://github.com/hypcode/uberspark.git
RUN opam switch 4.02 && eval `opam config env` && \
    cd uberspark/src && ./bsconfigure.sh && ./configure && \
    make && sudo make install && cd ../..
RUN opam switch 4.02 && eval `opam config env` && \
    cd uberspark/src/libs && ./bsconfigure.sh && ./configure && \
    make verify-ubersparklibs && make build-ubersparklibs && \
    sudo make install && cd ../../..

ENTRYPOINT /bin/bash
