#!/bin/bash
docker run -it --rm --hostname fortify-sca --name sca-dev --network=fortify-network --ip=172.50.0.14  --add-host=fortify-ssc:172.50.0.12 --add-host=fortify-scancentral:172.50.0.13 pedrogarciamf/fortify-sca:dev

