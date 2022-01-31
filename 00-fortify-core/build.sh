#!/bin/bash
docker build -t pedrogarciamf/fortify-centos:8 .

docker run -it --rm --name fortify-centos pedrogarciamf/fortify-centos:8