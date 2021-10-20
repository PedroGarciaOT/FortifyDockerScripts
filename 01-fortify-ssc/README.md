# FortifyDockerScripts
My Fortify Docker Scripts for Fortify SSC Server with an active update site, as well as the downloads site.
In addition, the update site is configured to support:
- AWB SCA Auto Update
- Eclipse Remediation Plugin Update Site
- Eclipse Security Assistant Plugin Update Site

Before you start.
Add all the files that will be used to create this image to the folder setup/FortifyInstallers.
Files like:
- Fortify_XX.X.X.zip

Optionally you can add the following files to be add to the SSC Downloads folder - http://srv-fortify-linux:8180/ssc/downloads .
- Fortify_ScanCentral_Client_XX.X.X_x64.zip
- Fortify_SourceAndLibScanner_XX.X.X_x64.zip
- WebInspect_64_XX.X.zip
- WebInspectAgent_XX.X.zip
- SecurityToolkit_XX.X.zip

After starting the container for the first time copy the init.token using 
``` 
docker cp fortify-ssc:/home/microfocus/.fortify/ssc/init.token .

cat init.token && echo 
``` 

In case you need the scripts to create the database copy them using
```  
docker cp fortify-ssc:/tools/fortify/sql . 
``` 

Is case you are using MariaDB the JDBC URL will be something like this 
```  
jdbc:mysql://fortify-mysql:3306/ssc?sessionVariables=collation_connection=latin1_general_cs&rewriteBatchedStatements=true&useSSL=false
``` 

In case you are planning to use several instances or in case you want to save disk space I recommend flattening the container into a new image. 

In order to use this in a production environment, the SSL configuration should be added to the Tomcat Server.
