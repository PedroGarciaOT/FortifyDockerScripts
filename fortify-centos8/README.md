# FortifyDockerScripts
My Fortify Docker Scripts for a Core CentOS image that will be used by SSC, SCA and ScanCentral. 
My idea of a Core image is to have some core configurations standards in a single place.
Configurations like:
- Java
- Administrator User Account
- SSH Configuration

Before you start.
Add all the files that will be used to create this image need to be placed into the folder setup/FortifyInstallers.
Files like:
- jdk-8u251-linux-x64.tar.gz
- jdk-11.0.7_linux-x64_bin.tar.gz

To build this image use ''' docker build -t pedrogarciamf/fortify-centos:8 . '''

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 
