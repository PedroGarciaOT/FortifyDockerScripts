#!/bin/bash
echo "Service Starting"

docker start fortify-mysql

sleep 20

docker start fortify-ssc

sleep 30

docker start fortify-scancentral-sast

sleep 10

docker start fortify-sca-linux-8g

docker start nexus-iq-server

docker start fortify-jenkins

#docker start fortify-jenkins-agent

if [ $? -eq 0 ]
then
  echo "DemoEnv Started"
  exit 0
else
  echo "DemoEnv Service failed" >&2
  exit 1
fi

