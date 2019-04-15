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

# xz
# TODO RUN apt-get -y install xz-utils

# zig lang
RUN cd /tmp && curl -O -J -L curl -LO https://ziglang.org/download/0.4.0/zig-linux-x86_64-0.4.0.tar.xz \
    && tar xf zig-linux-x86_64-0.4.0.tar.xz \
    && mv /tmp/zig-linux-x86_64-0.4.0/zig /usr/bin/ \
    && mv /tmp/zig-linux-x86_64-0.4.0/lib/zig /usr/lib/ \
    && rm -rf zig-linux-x86_64-0.4.0.tar.xz zig-linux-x86_64-0.4.0

ENV HOME /mal
