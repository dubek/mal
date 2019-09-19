FROM ubuntu:18.04
MAINTAINER Joel Martin <github@martintribe.org>

##########################################################
# General requirements for testing or common across many
# implementations
##########################################################

RUN apt-get -y update

# Required for running tests
RUN apt-get -y install make python

# Some typical implementation and test requirements
RUN apt-get -y install curl libreadline-dev libedit-dev

RUN mkdir -p /mal
WORKDIR /mal

##########################################################
# Specific implementation requirements
##########################################################

RUN apt-get -y install g++
RUN apt-get -y install git

RUN cd /tmp && git clone https://github.com/wren-lang/wren.git \
    && cd wren \
    && make \
    && cp ./wren /usr/bin/ \
    && cd /tmp && rm -rf wren
