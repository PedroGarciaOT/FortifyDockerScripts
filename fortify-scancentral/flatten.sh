#!/bin/bash
echo "*** Creating fortify-scancentral:dev ***"
docker build -t pedrogarciamf/fortify-scancentral:dev .

echo "*** Starting scancentral-dev ***"
docker run --detach --hostname fortify-scancentral --publish 8280:8080 --name scancentral-dev --network=fortify-network --ip=172.50.0.13 --add-host=fortify-ssc:172.50.0.12 pedrogarciamf/fortify-scancentral:dev

sleep 120

echo "*** Stopping fortify-scancentral:dev ***"
docker stop scancentral-dev

sleep 30

echo "*** Flattening fortify-scancentral:dev ***"
docker export -o fortify-scancentral-dev.tar scancentral-dev 

echo "*** Importing fortify-scancentral:imported ***"
docker import fortify-scancentral-dev.tar pedrogarciamf/fortify-scancentral:imported

sleep 30

cd flattening
echo "*** Creating fortify-scancentral:latest ***"
docker build -t pedrogarciamf/fortify-scancentral:latest .

sleep 30

echo "*** Removing scancentral-dev ***"
docker rm scancentral-dev

echo "*** Creating fortify-scancentral volumes ***"
docker volume create fortify_scancentral_home
docker volume create fortify_scancentral_logs

echo "*** Starting fortify-scancentral ***"
docker run --detach --hostname fortify-scancentral --publish 8280:8080 --name fortify-scancentral --volume fortify_scancentral_home:/home/microfocus/.fortify --volume fortify_scancentral_logs:/tools/fortify/tomcat/logs --network=fortify-network --ip=172.50.0.13 --add-host=fortify-ssc:172.50.0.12 --add-host=srv-fortify-linux:172.50.0.1 pedrogarciamf/fortify-scancentral:latest

echo "*** Done!!! ***"