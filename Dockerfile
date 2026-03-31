FROM bitnami/kubectl:latest AS kubectl

FROM ubuntu:24.04

ARG TARGETARCH
ENV ARCH=$TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y locales

RUN locale-gen \
    en_US.UTF-8 &&\
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN apt-get -y --no-install-recommends install \
    acl \
    apt-transport-https \
    bash-completion \
    bc \
    binutils \
    ca-certificates \
    curl \
    dnsutils \
    dstat \
    git \
    gnupg \
    htop \
    iperf3 \
    iproute2 \
    iptables \
    iputils-ping \
    jq \
    less \
    lshw \
    lsof \
    man \
    mysql-client \
    nano \
    netcat-openbsd \
    nmap \
    p7zip-full \
    postgresql-client \
    psmisc \
    pv \
    redis-tools \
    rsync \
    socat \
    strace \
    sudo \
    sysstat \
    tcpdump \
    telnet \
    tig \
    traceroute \
    tree \
    vim \
    wget

# Install MongoSH
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get -y install mongodb-mongosh

# Install Kubectl
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Install Azure CLI
RUN	curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Temporal CLI
RUN curl -sSf https://temporal.download/cli.sh | bash

RUN curl -L -o /tmp/nats.deb \
    https://github.com/nats-io/natscli/releases/download/v0.0.35/nats-0.0.35-${ARCH}.deb && \
    apt-get install -y /tmp/nats.deb && \
    rm /tmp/nats.deb

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

WORKDIR /home/ubuntu

ENV TERM=xterm-256color

USER ubuntu
