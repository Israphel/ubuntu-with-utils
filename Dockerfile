FROM bitnami/kubectl:1.28.7 as kubectl

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y locales

RUN locale-gen \
    en_US.UTF-8 &&\
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN apt-get -y install \
    apt-transport-https gnupg2 \
    bash-completion vim nano less man jq bc \
    lsof tree psmisc htop lshw sysstat dstat \
    iproute2 iputils-ping iptables dnsutils traceroute \
    netcat curl wget nmap socat netcat-openbsd rsync \
    p7zip-full \
    git tig \
    binutils acl pv \
    strace tcpdump \
    mysql-client postgresql-client redis-tools \
    sudo

# Install MongoSH
RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && \
    apt-get -y install mongodb-mongosh

# Install Kubectl
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Install Azure CLI
RUN	curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "ubuntu" ubuntu && \
    adduser ubuntu sudo && \
    echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    touch /home/ubuntu/.sudo_as_admin_successful && \
    chown -R root:sudo /usr/local

RUN cp /home/ubuntu/.bashrc /root/.bashrc

WORKDIR /home/ubuntu

ENV TERM=xterm-256color

USER ubuntu
