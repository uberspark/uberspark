FROM amd64/ubuntu:16.04
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

RUN apt-get update &&\
    apt-get -yqq install gcc-4.9-arm-linux-gnueabihf \
    	    	 	 gcc-4.9-multilib-arm-linux-gnueabihf binutils &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-4.9 /usr/bin/gcc


