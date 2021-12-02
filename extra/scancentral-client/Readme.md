Download ScanCentral Client from the controller Web API
```
curl https://hostname/scancentral-ctrl/rest/v2/update/download -H "fortify-client: CHANGEME321!" -o scancentral_latest.zip
```
Download ScanCentral Client from the controller Web API using the fortify-network docker network

```
curl http://scancentral-sast:8080/scancentral-ctrl/rest/v2/update/download -H "fortify-client: 3ClientToken!" -o scancentral_latest.zip
```
