
FROM ocaml/opam2:ubuntu-16.04
LABEL maintainer "Josh Schlichting <schlichj11@gmail.com>"

RUN sudo apt-get update && \
    sudo apt-get install -y m4 libgmp-dev \
    	 	 wget autoconf libgtksourceview2.0-dev
		 
RUN opam init
RUN opam switch 4.02
RUN opam update

RUN eval `opam config env`
RUN opam install -j 2 coq=8.6.1

RUN opam install menhir=20170712 depext zarith
RUN opam depext menhir=20170712 depext zarith camlzip
RUN opam install alt-ergo
RUN opam install -j 2 why3.0.87.3
RUN opam install yojson
RUN eval `opam config env`

RUN mkdir run
WORKDIR run
RUN wget http://compcert.inria.fr/release/compcert-3.1.tgz 
RUN tar -xvzf compcert-3.1.tgz
RUN opam switch 4.02 && eval `opam config env` && \
    cd CompCert-3.1 && ./configure x86_32-linux && \
    make all && sudo make install && cd ..
RUN wget http://frama-c.com/download/frama-c-Phosphorus-20170501.tar.gz
RUN tar -xvzf frama-c-Phosphorus-20170501.tar.gz
RUN opam switch 4.02 && eval `opam config env` && \
    cd frama-c-Phosphorus-20170501 && ./configure && \
    make && sudo make install && cd ..
RUN wget http://www.cs.nyu.edu/acsys/cvc3/releases/2.4.1/linux64/cvc3-2.4.1-optimized-static.tar.gz
RUN sudo cp -R cvc3-2.4.1-optimized-static/* /usr/local/
RUN tar -xzf cvc3-2.4.1-optimized-static.tar.gz
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.4.1/z3-4.4.1-x64-ubuntu-14.04.zip
RUN unzip z3-4.4.1-x64-ubuntu-14.04.zip
RUN sudo cp z3-4.4.1-x64-ubuntu-14.04/bin/z3 /usr/local/bin
RUN git clone https://github.com/hypcode/uberspark.git

ENTRYPOINT /bin/bash
