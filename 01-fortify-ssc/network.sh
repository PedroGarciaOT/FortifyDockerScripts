#!/bin/bash
docker network create --driver=bridge --subnet=172.50.0.0/25 --gateway=172.50.0.1 fortify-network