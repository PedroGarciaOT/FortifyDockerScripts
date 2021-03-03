# FortifyDockerScripts
My Fortify Docker Scripts for Fortify ScanCentral Controller. 

Before you start. 
Add all the files that will be used to create this image need to be placed into the folder setup/FortifyInstallers.
Files like:
- Fortify_ScanCentral_Controller_20.1.0.zip

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 

In order to use this in a production environment, the SSL configuration has to be added.
