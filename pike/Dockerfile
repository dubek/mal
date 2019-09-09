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

RUN apt-get -y install g++ libgmp-dev libpcre3-dev

RUN cd /tmp && curl -fsSLO https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz \
    && tar xf Pike-v8.0.702.tar.gz \
    && cd Pike-v8.0.702 \
    && make install CONFIGUREARGS="--without-devpoll --without-gdbm --without-zlib --without-mysql --without-nettle" \
    && cd /tmp && rm -rf /tmp/Pike-v8.0.702.tar.gz /tmp/Pike-v8.0.702

ENV HOME /mal
