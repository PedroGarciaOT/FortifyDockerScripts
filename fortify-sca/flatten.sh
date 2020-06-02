#!/bin/bash
echo "*** Creating fortify-sca:dev ***"
docker build -t pedrogarciamf/fortify-sca:dev .

echo "*** Starting sca-dev ***"
docker run --detach --hostname fortify-sca-dev --name sca-dev --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=fortify-scancentral:172.50.0.13 pedrogarciamf/fortify-sca:dev

sleep 120

echo "*** Stopping fortify-sca:dev ***"
docker stop sca-dev

sleep 30

echo "*** Flattening fortify-sca:dev ***"
docker export -o fortify-sca-dev.tar sca-dev 

echo "*** Importing fortify-sca:imported ***"
docker import fortify-sca-dev.tar pedrogarciamf/fortify-sca:imported

sleep 30

cd flattening
echo "*** Creating fortify-sca:latest ***"
docker build -t pedrogarciamf/fortify-sca:latest .

sleep 30

echo "*** Removing sca-dev ***"
docker rm sca-dev

echo "*** Creating fortify-sca volumes ***"
docker volume create fortify_sca_home
docker volume create fortify_sca_workdir

echo "*** Starting fortify-sca ***"
docker run --detach --hostname fortify-sca --name fortify-sca --mount type=bind,src=/opt/fortify/fortify.license,dst=/tools/fortify/sca/fortify.license --volume fortify_sca_home:/home/microfocus/.fortify --volume fortify_sca_workdir:/ScanCentralWorkdir --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=fortify-scancentral:172.50.0.13 pedrogarciamf/fortify-sca:latest

echo "*** Done!!! ***"