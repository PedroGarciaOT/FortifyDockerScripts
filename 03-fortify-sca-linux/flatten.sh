#!/bin/bash
echo "*** Creating fortify-sca:dev-linux ***"
docker build -t pedrogarciamf/fortify-sca:dev-linux .

echo "*** Starting sca-dev ***"
docker run --detach --hostname fortify-sca-linux --name sca-dev-linux --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=scancentral-sast:172.50.0.13 pedrogarciamf/fortify-sca:dev-linux

sleep 120

echo "*** Stopping fortify-sca:dev-linux ***"
docker stop sca-dev-linux

sleep 30

echo "*** Flattening fortify-sca:dev-linux ***"
docker export -o fortify-sca-dev-linux.tar sca-dev-linux 

echo "*** Importing fortify-sca:imported-linux ***"
docker import fortify-sca-dev-linux.tar pedrogarciamf/fortify-sca:imported-linux

sleep 30

cd flattening
echo "*** Creating fortify-sca:latest-linux ***"
docker build -t pedrogarciamf/fortify-sca:latest-linux .

sleep 30

echo "*** Removing sca-dev-linux ***"
docker rm sca-dev-linux

echo "*** Creating fortify-sca-linux volumes ***"
docker volume create fortify_sca_linux_workdir

if [ ! -f "/opt/fortify/fortify.license" ]; then 
    mkdir -p /opt/fortify/
    cp setup/FortifyInstallers/fortify.license /opt/fortify/
fi

echo "*** Starting fortify-sca-linux ***"
docker run --detach --memory=8g --hostname fortify-sca-linux --name fortify-sca-linux-8g --mount type=bind,src=/opt/fortify/fortify.license,dst=/tools/fortify/sca/fortify.license --volume fortify_sca_linux_workdir:/ScanCentralWorkdir --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=scancentral-sast:172.50.0.13 pedrogarciamf/fortify-sca:latest-linux

echo "*** Done!!! ***"