FROM centos:centos8

COPY setup /setup

WORKDIR /setup

RUN yum -y update && yum -y install epel-release && yum -y install yum-utils && yum -y install sudo && yum -y install unzip && yum -y install zip && yum -y install vim-enhanced && yum -y install apr-devel && yum -y install openssl-devel && yum -y install make && yum -y install dos2unix && yum -y install wget && yum -y groupinstall "Development Tools"

RUN groupadd -r microfocus && useradd -m -r -g microfocus microfocus && usermod -aG wheel microfocus

RUN sudo cp /etc/sudoers /root/sudoers.bak && echo "microfocus ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN cp colorls.* /etc/profile.d/ && source /etc/profile.d/colorls.sh

RUN mkdir -p /tools/java/jdk-11

RUN tar -pxzf FortifyInstallers/jdk-11_latest_linux-x64_bin.tar.gz -C /tools/java/jdk-11 --strip-components=1 && echo "export JAVA_HOME=/tools/java/jdk-11" >> /etc/bashrc && echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/bashrc && echo "alias ll='ls -alF --color=auto'" >> /etc/bashrc && source /etc/bashrc

RUN chown -R microfocus:microfocus /tools

ENV JAVA_MAJOR=11 \
    JAVA_HOME=/tools/java/jdk-11

WORKDIR /home/microfocus

RUN rm -rf /setup

USER microfocus

RUN /tools/java/jdk-11/bin/keytool -alias fortify -dname CN=Fortify -genkeypair -keyalg RSA -keypass M1cro_F0cus -storepass M1cro_F0cus -storetype pkcs12 -validity 999

RUN /tools/java/jdk-11/bin/keytool -alias fortify -exportcert -file /home/microfocus/FortifyCert.cer -storepass M1cro_F0cus 

RUN /tools/java/jdk-11/bin/keytool -alias fortify -importcert -trustcacerts -cacerts -file /home/microfocus/FortifyCert.cer -storepass changeit -noprompt

USER root
