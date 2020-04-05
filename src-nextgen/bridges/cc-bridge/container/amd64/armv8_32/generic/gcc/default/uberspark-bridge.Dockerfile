FROM amd64/ubuntu:16.04
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

RUN apt-get update &&\
    apt-get -yqq install gcc-arm-linux-gnueabihf \
    	    	 	 gcc-multilib-arm-linux-gnueabihf \
			 binutils-arm-linux-gnueabihf &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    ln -s /usr/bin/arm-linux-gnueabihf-gcc /usr/bin/gcc


