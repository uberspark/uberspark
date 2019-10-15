FROM ocaml/opam2:alpine-3.9-opam
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all

RUN sudo apk update 

CMD ${D_CMD} ${D_CMDARGS}
