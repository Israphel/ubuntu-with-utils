FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

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

RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc \
    | apt-key add - && \
    echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list && \
    apt-get update && \
    apt-get install mongodb-mongosh

RUN rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "ubuntu" ubuntu && \
    adduser ubuntu sudo && \
    echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    touch /home/ubuntu/.sudo_as_admin_successful && \
    chown -R root:sudo /usr/local

RUN cp /home/ubuntu/.bashrc /root/.bashrc

WORKDIR /home/ubuntu

USER ubuntu
