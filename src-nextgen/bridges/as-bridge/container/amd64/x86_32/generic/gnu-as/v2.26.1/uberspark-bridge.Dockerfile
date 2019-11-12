FROM amd64/ubuntu:16.04
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

RUN apt-get update &&\
    apt-get -y install gcc gcc-multilib binutils

