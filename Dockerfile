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
                    libnetfilter-conntrack3 && \
    apt-get clean

# Install packages
ADD squid3-20140505.tgz /tmp
RUN cd /tmp && \
    dpkg -i debs/*.deb && \
    rm -rf /tmp/debs && \
    apt-get clean

# Soon...
# RUN cd /tmp && \
#     wget ...URL FROM GITHUB RELEASE... && \
#     tar xzf squid3-20140505.tgz \
#     dpkg -i debs/*.deb && \
#     rm -rf /tmp/debs

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
