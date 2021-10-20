#!/bin/bash
echo "Starting Fortify ScanCentral Sensor"
echo "FORTIFY_SCA_MAJOR='${FORTIFY_SCA_MAJOR}'"
echo "FORTIFY_SCA_HOME='${FORTIFY_SCA_HOME}'"
echo "FORTIFY_SCANCENTRAL_URL='${FORTIFY_SCANCENTRAL_URL}'"
${FORTIFY_SCA_HOME}/bin/scancentral -url ${FORTIFY_SCANCENTRAL_URL} worker
