#!/bin/bash

#dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine -y

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf update -y 
dnf install docker-ce docker-ce-cli containerd.io -y 

systemctl enable docker
systemctl start docker

#pip3 install --upgrade pip
#pip3 install docker-compose

curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod a+x /usr/local/bin/docker-compose

ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $NF}')/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

docker-compose --version