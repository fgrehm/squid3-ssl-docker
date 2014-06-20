# Dockerfile.build
# Build debian packages for Squid3, with SSL enabled.
# http://www.squid-cache.org/

FROM ubuntu:trusty
MAINTAINER Fabio Rehm <fgrehm@gmail.com>

RUN echo "deb-src http://archive.ubuntu.com/ubuntu trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Install build dependencies
RUN apt-get -y install libssl-dev
RUN apt-get -y build-dep squid3

# Download source
RUN mkdir /src
RUN cd /src && apt-get source squid3
RUN apt-get build-dep openssh -y
RUN apt-get build-dep openssl -y

# Edit debian/rules to build with SSL
RUN sed -i 's/--enable-ecap/--enable-ecap --enable-ssl --enable-ssl-crtd/' /src/squid3-3.3.8/debian/rules

# Build debs
RUN apt-get -y install devscripts
RUN cd /src/squid3-3.3.8 && debuild -us -uc -b
