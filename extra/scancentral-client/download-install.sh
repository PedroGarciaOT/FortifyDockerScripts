#!/bin/bash
#curl "https://hostname/scancentra-ctrl/rest/v2/update/download" -H "fortify-client: 3ClientToken!" -o scancentral.zip
curl "https://hostname/scancentra-ctrl/rest/v3/update/download/<client_version_you_need>" -H "fortify-client: 3ClientToken!" -o scancentral.zip
unzip -qq scancentral.zip 
#create client.properties client_auth_token=3ClientToken!
java -version
scancentral -version