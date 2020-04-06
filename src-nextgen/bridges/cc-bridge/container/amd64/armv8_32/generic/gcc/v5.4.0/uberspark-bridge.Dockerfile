FROM amd64/ubuntu:16.04
LABEL maintainer="Amit Vasudevan <amitvasudevan@acm.org>, Matt McCormack <matthew.mccormack@live.com>" author="Matt McCormack <matthew.mccormack@live.com>"

RUN apt-get update &&\
    apt-get -yqq install gcc-5-arm-linux-gnueabihf \
    	    	 	 gcc-5-multilib-arm-linux-gnueabihf \
			 binutils-arm-linux-gnueabihf &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/gcc


