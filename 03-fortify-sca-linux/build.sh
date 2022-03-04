#!/bin/bash
docker build -t pedrogarciamf/fortify-sca:dev .

docker run -it --rm --hostname fortify-sca-dev-linux --name sca-dev --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=scancentral-sast:172.50.0.13 pedrogarciamf/fortify-sca:dev
