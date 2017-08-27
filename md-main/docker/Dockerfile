FROM ruby:2.3.1
MAINTAINER Andrey Kumanyaev <me@zzet.org>

RUN apt-get update -qq && \
    apt-get install -y  apt-utils \
                        git \
                        autoconf \
                        bison \
                        build-essential \
                        libssl-dev \
                        libyaml-dev \
                        libreadline6-dev \
                        zlib1g-dev \
                        libncurses5-dev \
                        python-pip \
                        python-dev \
                        htop \
                        vim \
                        libpq-dev \
                        libmagickwand-dev \
                        imagemagick \
                        nodejs \
                        npm && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

