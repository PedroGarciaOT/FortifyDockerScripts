write-host "Starting scancentral-dast-sensor container"
docker run -d --restart always --name scancentral-dast-sensor -e "mode=3" -e "RCServerHost=+" -e "RCServerPort=8089" -e "RCServerUseHTTPS=false" -e "RCServerAuthType=none" -e "DASTApiRootUrl=http://192.168.35.48:81" -e "AllowNonTrustedServerCertificate=true" -e "ServiceToken=PSWHMWiKBK6A46WcvGD3jQ==" -e "ScannerPoolId=0"  --memory=16g --cpus=2 fortifydocker/webinspect:21.2.74
write-host "Starting scancentral-dast-sensor container completed"
