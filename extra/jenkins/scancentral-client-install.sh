#!/bin/bash
rm -rf ${JENKINS_HOME}/fortify
mkdir -p ${JENKINS_HOME}/fortify
wget http://srv-fortify-linux:8180/ssc/downloads/scancentral.zip 
unzip -qq scancentral.zip -d ${JENKINS_HOME}/fortify
wget http://srv-fortify-linux:8180/ssc/downloads/scancentral.properties -O ${JENKINS_HOME}/fortify/Core/config/scancentral.properties
wget http://srv-fortify-linux:8180/ssc/downloads/client.properties -O ${JENKINS_HOME}/fortify/Core/config/client.properties
rm -rf ${JENKINS_HOME}/fortify/bin/*.bat
rm -rf ${JENKINS_HOME}/fortify/bin/scancentral-worker-service
chmod a+x ${JENKINS_HOME}/fortify/bin/*
export PATH=$PATH:${JENKINS_HOME}/fortify/bin
scancentral -h