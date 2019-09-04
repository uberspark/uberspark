FROM ubuntu:16.04
LABEL author="Amit Vasudevan <amitvasudevan@acm.org>"

# update package repositories
RUN apt-get update

# setup default user
RUN apt-get install sudo
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker

# update apt cache
RUN sudo apt-get update

# switch to working directory within container
WORKDIR "/home/docker"


#COPY configure.ac /home/docker/.

ENTRYPOINT /bin/bash
