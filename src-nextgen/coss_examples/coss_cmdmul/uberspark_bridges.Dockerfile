FROM amd64/alpine-3.10.2
MAINTAINER Amit Vasudevan <amitvasudevan@acm.org>

# runtime arguments
ENV D_CMD=make
ENV D_CMDARGS=all

RUN sudo apk update 

CMD ${D_CMD} ${D_CMDARGS}
