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
    apt-transport-https \
    bash-completion vim less man jq bc \
    lsof tree psmisc htop lshw sysstat dstat \
    iproute2 iputils-ping iptables dnsutils traceroute \
    netcat curl wget nmap socat netcat-openbsd rsync \
    p7zip-full \
    git tig \
    binutils acl pv \
    strace tcpdump \
    redis-tools \
    sudo &&\
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "ubuntu" ubuntu && \
    adduser ubuntu sudo && \
    echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    touch /home/ubuntu/.sudo_as_admin_successful && \
    chown -R root:sudo /usr/local

RUN cp /home/ubuntu/.bashrc /root/.bashrc

WORKDIR /home/ubuntu

USER ubuntu