# FortifyDockerScripts
My Fortify Docker Scripts for SSC, SCA and ScanCentral SAST. 

In order to setup a demo/test environment you may follow the steps below

1. Create a new CentOS VM
For more details check [CentOS Documentation](https://docs.centos.org/)
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
3. Set up Docker Repo
``` 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```
4. Update DNF
``` 
dnf update -y 
```
5. Install Docker CE
``` 
dnf install docker-ce docker-ce-cli containerd.io -y 
```
6. Enable Docker with systemctl
``` 
systemctl enable docker 
```
7. Start Docker with systemctl
``` 
systemctl start docker 
```
8. Clone this project 
```
git clone --depth 1 "https://github.com/PedroGarciaMF/FortifyDockerScripts.git"
```
9. Enter the cloned project folder.
```
cd FortifyDockerScripts
```
10. Create a folder **FortifyInstallers**.
```
mkdir -p FortifyInstallers
```

11. Copy the files you downloaded from [Software Licenses and Downloads (SLD)](https://sld.microfocus.com/) into the **FortifyInstallers** folder.

12. Run the setup all script to create all the containers
``` 
chmod a+x setup-all.sh
./setup-all.sh
```

For more details check [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

