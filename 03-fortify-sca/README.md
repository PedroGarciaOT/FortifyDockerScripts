# FortifyDockerScripts
My Fortify Docker Scripts for Fortify SCA configured as a Fortify ScanCentral Sensor with support to:
- Java
- Maven
- Gradle
- Ant

Before you start.
Add all the files that will be used to create this image need to be placed into the folder setup/FortifyInstallers.
Files like:
- Fortify_XXXX.zip
- fortify.license

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 

However, the best approach would be to have Fortify SCA configured as a Fortify ScanCentral Sensor in one image and the supported build tools and languages in another image created on top of that image.