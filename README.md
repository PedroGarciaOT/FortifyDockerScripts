# FortifyDockerScripts
My Fortify Docker Scripts for SSC, SCA and ScanCentral SAST. 

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
3. Update DNF
``` 
dnf update -y 
```
4. Set up Docker Repo
``` 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```
5. Install containerd.io
``` 
dnf install containerd.io
```
6. Install Docker CE
``` 
dnf install docker-ce docker-ce-cli -y 
```
7. Enable Docker with systemctl
``` 
systemctl enable docker 
```
8. Start Docker with systemctl
``` 
systemctl start docker 
```
9. Clone this project 
```
git clone --depth 1 "https://github.com/PedroGarciaMF/FortifyDockerScripts.git"
```
10. Enter the cloned project folder.
```
cd FortifyDockerScripts
```
11. Create a folder **FortifyInstallers**.

12. Copy the files from the you downloaded from [Software Licenses and Downloads (SLD)](https://sld.microfocus.com/) into the **FortifyInstallers** folder.

13. Run the setup all script to create all the containers
``` 
chmod a+x setup-all.sh
./setup-all.sh
```

For more details check [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

