echo "*** Creating fortify-sca:latest-win ***"
docker build -t pedrogarciamf/fortify-sca:latest-win .

echo "*** Creating fortify-sca-win volumes ***"
docker volume create fortify_sca_win_workdir

rem #Todo license mapping 

echo "*** Starting fortify-sca-win ***"
rem FIXME docker network

docker run --detach --memory=8g --hostname fortify-sca-win --name fortify-sca-win-8g --volume fortify_sca_win_workdir:C:\ScanCentralWorkdir --restart=always pedrogarciamf/fortify-sca:latest-win

echo "*** Done!!! ***"