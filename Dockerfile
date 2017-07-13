# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

FROM ubuntu:16.04
MAINTAINER Betacloud Solutions GmbH (https://www.betacloud-solutions.de)

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION:-latest}

ARG RSYNC_AUTHORIZED_KEYS

ADD files/run.sh /run.sh
RUN apt-get update \ 
    && apt-get install -y \ 
        rsync \
        openssh-server \
    && chmod +x /run.sh \
    && useradd -m -d /var/lib/rsync rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER rsync
EXPOSE 22
ENTRYPOINT ["/run.sh"]
