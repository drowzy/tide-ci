FROM ubuntu:14.04
RUN mkdir demo
RUN apt-get update
RUN apt-get -y install vim git
