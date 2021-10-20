#!/bin/bash
docker build -t pedrogarciamf/fortify-ssc:dev .

docker run -it --rm --hostname fortify-ssc --publish 8080:8080 --publish 8443:8443 --name ssc-dev --network=fortify-network --ip=172.50.0.12 --add-host=fortify-mysql:172.50.0.10 --add-host=scancentral-sast:172.50.0.13 pedrogarciamf/fortify-ssc:dev
