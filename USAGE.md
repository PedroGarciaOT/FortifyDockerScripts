# FortifyDockerScripts
My Fortify Docker Scripts for SSC, SCA and ScanCentral SAST. 

In order to setup a demo/test environment you may follow the steps below

1. Create a new CentOS VM
For more details check [CentOS Documentation](https://docs.centos.org/)
2. Clone this project 
```
git clone --depth 1 "https://github.com/PedroGarciaMF/FortifyDockerScripts.git"
```
3. Enter the cloned project folder.
```
cd FortifyDockerScripts
```
4. Create and enter **FortifyInstallers** folder.
```
mkdir -p FortifyInstallers
```

5. Download the latest installers and patches from [Software Licenses and Downloads (SLD)](https://sld.microfocus.com/).

6. Update prepare.sh.

7. Run the setup-linux script to create all linux containers
``` 
chmod a+x setup-linux.sh
./setup-linux.sh
```

For more details check [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

