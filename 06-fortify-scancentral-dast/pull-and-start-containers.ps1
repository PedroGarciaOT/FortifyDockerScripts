write-host "Pulling fortifydocker/webinspect:21.2.74 image"
docker pull fortifydocker/webinspect:21.2.74
write-host "Pulling fortifydocker/webinspect:21.2.74 image completed"
write-host "Pulling fortifydocker/scancentral-dast-api:21.2 image"
docker pull fortifydocker/scancentral-dast-api:21.2
write-host "Pulling fortifydocker/scancentral-dast-api:21.2 image completed"
write-host "Pulling fortifydocker/scancentral-dast-globalservice:21.2 image"
docker pull fortifydocker/scancentral-dast-globalservice:21.2
write-host "Pulling fortifydocker/scancentral-dast-globalservice:21.2 image completed"
write-host "All images have been pulled"
write-host "Starting scancentral-dast-utilityservice container"
docker run -d --restart always -p 82:5000 --name scancentral-dast-utilityservice -e "ConnectionStrings:DASTDB=H7ExeljHHr+2KWode2f60FgbD0EssfcmKMo8waaQkHpv3yXFrjARsdibDrdMHKcIZfj3Myo7hwKclnaOo8HLJZ0cwBzuywHEN1SeJ4goYbLdIY6Lfg7CWw==" -e "Mode=4" -e "ASPNETCORE_URLS=http://+:5000" fortifydocker/webinspect:21.2.74
write-host "Starting scancentral-dast-utilityservice container completed"
write-host "Starting scancentral-dast-api container"
docker run -d --restart always -p 81:80 --name scancentral-dast-api -e "ConnectionStrings:DASTDB=H7ExeljHHr+2KWode2f60FgbD0EssfcmKMo8waaQkHpv3yXFrjARsdibDrdMHKcIZfj3Myo7hwKclnaOo8HLJZ0cwBzuywHEN1SeJ4goYbLdIY6Lfg7CWw==" fortifydocker/scancentral-dast-api:21.2
write-host "Starting scancentral-dast-api container completed"
write-host "Starting scancentral-dast-globalservice container"
docker run -d --restart always --name scancentral-dast-globalservice -e "ConnectionStrings:DASTDB=H7ExeljHHr+2KWode2f60FgbD0EssfcmKMo8waaQkHpv3yXFrjARsdibDrdMHKcIZfj3Myo7hwKclnaOo8HLJZ0cwBzuywHEN1SeJ4goYbLdIY6Lfg7CWw==" fortifydocker/scancentral-dast-globalservice:21.2
write-host "Starting scancentral-dast-globalservice container completed"
write-host "All containers have been started"
