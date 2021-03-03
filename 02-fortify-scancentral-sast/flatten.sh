#!/bin/bash
echo "*** Creating fortify-scancentral-sast:dev ***"
docker build -t pedrogarciamf/fortify-scancentral-sast:dev .

echo "*** Starting scancentral-dev ***"
docker run --detach --hostname scancentral-sast --publish 8280:8080 --name scancentral-dev --network=fortify-network --ip=172.50.0.13 --add-host=fortify-ssc:172.50.0.12 pedrogarciamf/fortify-scancentral-sast:dev

sleep 120

echo "*** Stopping fortify-scancentral-sast:dev ***"
docker stop scancentral-dev

sleep 30

echo "*** Flattening fortify-scancentral-sast:dev ***"
docker export -o fortify-scancentral-dev.tar scancentral-dev 

echo "*** Importing fortify-scancentral-sast:imported ***"
docker import fortify-scancentral-dev.tar pedrogarciamf/fortify-scancentral-sast:imported

sleep 30

cd flattening
echo "*** Creating fortify-scancentral-sast:latest ***"
docker build -t pedrogarciamf/fortify-scancentral-sast:latest .

sleep 30

echo "*** Removing scancentral-dev ***"
docker rm scancentral-dev

echo "*** Creating fortify-scancentral-sast volumes ***"
docker volume create scancentral_sast_home
docker volume create scancentral_sast_logs

echo "*** Starting fortify-scancentral-sast ***"
docker run --detach --hostname scancentral-sast --publish 8280:8080 --name fortify-scancentral-sast --volume scancentral_sast_home:/home/microfocus/.fortify --volume scancentral_sast_logs:/tools/fortify/tomcat/logs --network=fortify-network --ip=172.50.0.13 --add-host=fortify-ssc:172.50.0.12 --add-host=srv-fortify-linux:172.50.0.1 pedrogarciamf/fortify-scancentral-sast:latest

echo "*** Done!!! ***"