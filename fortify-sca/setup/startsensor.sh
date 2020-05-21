#!/bin/bash
echo "Starting Fortify CloudScan Sensor"
echo "FORTIFY_HOME='${FORTIFY_HOME}'"
echo "FORTIFY_SCANCENTRAL_URL='${FORTIFY_SCANCENTRAL_URL}'"
${FORTIFY_HOME}/bin/cloudscan -url ${FORTIFY_SCANCENTRAL_URL} worker
