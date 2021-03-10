#!/bin/bash
echo "Stopping DemoEnv"
#docker stop fortify-jenkins-agent

docker stop fortify-jenkins

docker stop fortify-sca-8g

docker stop fortify-scancentral-sast

docker stop fortify-ssc

sleep 20

docker stop fortify-mysql

if [ $? -eq 0 ]
then
  echo "DemoEnv Stoped"
  exit 0
else
  echo "DemoEnv Service failed" >&2
  exit 1
fi

