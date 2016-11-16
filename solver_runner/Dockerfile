FROM ruby:2.3.1
MAINTAINER Yuya.Nishida.

RUN set -xe ; \
  apt-get update ; \
  apt-get install -y --no-install-recommends time ; \
  rm /bin/sleep ; \
  rm /usr/bin/perl* ; \
  rm -rf /var/lib/apt/lists/*
