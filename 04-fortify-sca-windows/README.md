# FortifyDockerScripts
My Fortify Docker Scripts for Fortify SCA configured as a Fortify ScanCentral Sensor.

Before you start.
Add all the files that will be used to create this image need to be placed into the folder setup/FortifyInstallers.
Files like:
- Fortify_SCA_and_Apps_XX.X.X_Windows.zip
- fortify.license

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 
