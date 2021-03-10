#!/bin/bash
stopdemoenv

docker stop mysql-admin

docker stop portainer

shutdown -P now
