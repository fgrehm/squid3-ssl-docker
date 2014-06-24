FROM ubuntu:trusty
MAINTAINER Fabio Rehm <fgrehm@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main" > /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates main" >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu trusty main" >> /etc/apt/sources.list && \
    echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -qq \
                    apache2 \
                    logrotate \
                    squid-langpack \
                    ca-certificates \
                    libgssapi-krb5-2 \
                    libltdl7 \
                    libecap2 \
                    libnetfilter-conntrack3 \
                    curl && \
    apt-get clean

# Install packages
RUN cd /tmp && \
    curl -L https://github.com/fgrehm/squid3-ssl-docker/releases/download/v20140623/squid3-20140623.tgz | tar xvz && \
    dpkg -i debs/*.deb && \
    rm -rf /tmp/debs && \
    apt-get clean

# Create cache directory
VOLUME /var/cache/squid3

# Initialize dynamic certs directory
RUN /usr/lib/squid3/ssl_crtd -c -s /var/lib/ssl_db
RUN chown -R proxy:proxy /var/lib/ssl_db

# Prepare configs and executable
ADD squid.conf /etc/squid3/squid.conf
ADD openssl.cnf /etc/squid3/openssl.cnf
ADD mk-certs /usr/local/bin/mk-certs
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 3128
CMD ["/usr/local/bin/run"]
