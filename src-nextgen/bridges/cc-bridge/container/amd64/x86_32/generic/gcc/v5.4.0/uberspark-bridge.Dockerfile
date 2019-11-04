FROM amd64/ubuntu:16.04
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=placeholder

RUN apt-get update &&\
    apt-get -y install gcc binutils

#CMD ["/bin/sh", "-c", "${D_CMD}"]
