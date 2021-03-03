#!/bin/bash
docker build -t pedrogarciamf/fortify-scancentral-sast:dev .

docker run -it --rm --hostname scancentral-sast --publish 8280:8080 --name scancentral-dev --network=fortify-network --ip=172.50.0.13  --add-host=fortify-ssc:172.50.0.12  pedrogarciamf/fortify-scancentral-sast:dev
