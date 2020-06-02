# FortifyDockerScripts
My Fortify Docker Scripts for SSC, SCA and ScanCentral. 

In order to setup a demo/test environment you may follow the steps below

1. Create a new CentOS VM
2. Remove any existing trace of docker
``` 
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```
3. Update YUM
``` 
yum update -y 
```
4. Set up Docker Repo
``` 
yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
5. Install containerd.io
``` 
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm

yum localinstall containerd.io-1.2.13-3.2.el7.x86_64.rpm -y
```
6. Install Docker CE
``` 
yum install docker-ce docker-ce-cli -y 
```
7. Enable Docker with systemctl
``` 
systemctl enable docker 
```
8. Start Docker with systemctl
``` 
systemctl start docker 
```
9. Create the Fortify Docker Network
``` 
docker network create --driver=bridge --subnet=172.50.0.0/25 --gateway=172.50.0.1 fortify-network 
```

For more details check [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

