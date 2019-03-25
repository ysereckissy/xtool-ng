FROM ubuntu:18.04

ARG CTNG_UID=1000
ARG CTNG_GID=1000

RUN groupadd -g $CTNG_GID ctng
RUN useradd -d /home/ctng -m -g $CTNG_GID -u $CTNG_UID -s /bin/bash ctng

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    gperf \
    bison \
    flex \
    texinfo \
    help2man \
    make \
    libncurses5-dev \
    python-dev \
    autoconf \
    automake \
    libtool \
    libtool-bin \
    gawk \
    wget \
    bzip2 \
    xz-utils \
    unzip \
    patch \
    libstdc++6
RUN wget -O /sbin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 \
    && chmod a+x /sbin/dumb-init \
    && echo 'export PATH=/opt/ctng/bin:$PATH' >> /etc/profile

# Downoad and compile crosstool-NG
RUN wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz 2>&1 && \
    tar xf crosstool-ng-*.tar.* && \
    cd crosstool-ng-1.23.0 && \
    ./configure && \
    make && \
    make install && \
    rm -rf ../crosstool-ng*

ENTRYPOINT ["/sbin/dumb-init", "--"]

