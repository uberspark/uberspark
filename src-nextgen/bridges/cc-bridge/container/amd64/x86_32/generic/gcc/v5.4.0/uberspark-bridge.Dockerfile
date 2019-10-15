FROM amd64/ubuntu:16.04
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all

RUN apt-get update &&\
    apt-get -y install gcc binutils

CMD ${D_CMD} ${D_CMDARGS}
