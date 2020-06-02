FROM centos:centos8

COPY setup /setup

WORKDIR /setup

RUN yum -y update && yum -y install epel-release && yum -y install yum-utils && yum -y install sudo && yum -y install unzip && yum -y install zip && yum -y install vim-enhanced && yum -y install apr-devel && yum -y install openssl-devel && yum -y install make && yum -y install dos2unix && yum -y install wget && yum -y groupinstall "Development Tools"

RUN groupadd -r microfocus && useradd -m -r -g microfocus microfocus && usermod -aG wheel microfocus

RUN sudo cp /etc/sudoers /root/sudoers.bak && echo "microfocus ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN cp colorls.* /etc/profile.d/ && source /etc/profile.d/colorls.sh

RUN mkdir -p /tools/java/jdk-8

RUN mkdir -p /tools/java/jdk-11

RUN tar -pxzf FortifyInstallers/jdk-8u251-linux-x64.tar.gz -C /tools/java/jdk-8 --strip-components=1 && echo "export JAVA_HOME=/tools/java/jdk-8" >> /etc/bashrc && echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bashrc && echo "alias ll='ls -laF --color=auto'" >> /etc/bashrc && source /etc/bashrc

RUN tar -pxzf FortifyInstallers/jdk-11.0.7_linux-x64_bin.tar.gz -C /tools/java/jdk-11 --strip-components=1

RUN chown -R microfocus:microfocus /tools

ENV JAVA_MAJOR=8 \
    JAVA_VERSION=1.8.0_251 \
    JAVA_HOME=/tools/java/jdk-8

WORKDIR /home/microfocus

RUN rm -rf /setup
