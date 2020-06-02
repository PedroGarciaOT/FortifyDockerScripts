# FortifyDockerScripts
My Fortify Docker Scripts for Fortify SSC Server with an active update site, as well as the downloads site.
In addition, the update site is configured to support:
- AWB SCA Auto Update
- Eclipse Remediation Plugin Update Site
- Eclipse Security Assistant Plugin Update Site

Before you start.
Add all the files that will be used to create this image need to be placed into the folder setup/FortifyInstallers.
Files like:
- Fortify_20.1.0.zip
- ojdbc8.jar - In case you are planning on using Oracle Database
Optionally you can add the following files to be add to the SSC Downloads folder - http://srv-fortify-linux:8180/ssc/downloads .
- Fortify_ScanCentral_Client_20.1.0_x64.zip
- SecurityToolkit_20.1.zip
- SourceAndLibScanner-20.1.0-plus-doc.zip
- WebInspect_64_20.1.zip
- WebInspectAgent_20.1.zip

After starting the container for the first time copy the init.token using 
``` 
docker cp fortify-ssc:/home/microfocus/.fortify/ssc/init.token .

cat init.token && echo 
``` 

In case you need the scripts to create the database copy them using
```  
docker cp fortify-ssc:/tools/fortify/sql . 
``` 

Is case you are using MySQL the JDBC URL will be something like this 
```  
jdbc:mysql://fortify-mysql:3306/ssc?connectionCollation=latin1_general_cs&rewriteBatchedStatements=true&useSSL=false 
``` 

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 

In order to use this in a production environment, the SSL configuration has to be added.
