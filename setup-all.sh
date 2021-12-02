#!/bin/bash
# Setup COE in Linux
# Requires Docker to be up and running
# Requires dos2unix

echo "          "
echo "Starting"
echo "          "

chmod a+x *.sh

./install-tools.sh

dos2unix prepare.sh

./prepare.sh

docker volume create portainer_data

docker run --detach --hostname portainer --publish 9000:9000 --name portainer --restart always --volume /var/run/docker.sock:/var/run/docker.sock --volume portainer_data:/data portainer/portainer:latest

cd 00-fortify-centos8

docker build -t pedrogarciamf/fortify-centos:8 .

cd ../01-fortify-ssc

dos2unix *.sh
chmod a+x *.sh

./network.sh

docker run --detach --hostname fortify-mysql --publish 3306:3306 --publish 33060:33060 --name fortify-mysql --mount type=bind,src=/opt/mysql/config/my.cnf,dst=/etc/my.cnf --mount type=bind,src=/opt/mysql/data,dst=/var/lib/mysql --env MYSQL_ROOT_PASSWORD=M1cro_F0cus --env MYSQL_USER=microfocus --env MYSQL_PASSWORD=M1cro_F0cus --network=fortify-network --ip=172.50.0.10 mysql:8.0

sleep 60

docker run --detach --hostname mysql-admin --publish 9200:80 --name mysql-admin --env PMA_HOST=fortify-mysql --env PMA_PORT=3306 --env PMA_USER=root --env PMA_PASSWORD=M1cro_F0cus --env PMA_ARBITRARY=0 --env PMA_ABSOLUTE_URI=http://mysql-admin/ --network=fortify-network --ip=172.50.0.11   --add-host=fortify-mysql:172.50.0.10 phpmyadmin/phpmyadmin:latest

sleep 30

./flatten.sh

cd ../02-fortify-scancentral-sast

dos2unix *.sh
chmod a+x *.sh

sleep 30

./flatten.sh

cd ../03-fortify-sca-linux

dos2unix *.sh
chmod a+x *.sh

sleep 30

./flatten.sh

cd ../

docker volume create fortify_jenkins_home

docker run --detach --hostname fortify-jenkins --publish 8585:8080 --publish 50000:50000 --name fortify-jenkins --volume fortify_jenkins_home:/var/jenkins_home --network=fortify-network --ip=172.50.0.3 --add-host=fortify-gitlab:172.50.0.4 --add-host=fortify-nexus:172.50.0.5 --add-host=fortify-dtrack:172.50.0.6 --add-host=fortify-sonar:172.50.0.9 --add-host=fortify-ssc:172.50.0.12 --add-host=scancentral-sast:172.50.0.13 jenkins/jenkins:lts

docker ps -a

docker images

#Starting extras
#docker pull internetsystemsconsortium/bind9:9.11
#docker pull registry
#docker pull nginx
#nexusiq

mkdir -p /opt/demoenv/
cp -r extra/demoenv/* /opt/demoenv/ 
chmod a+x /opt/demoenv/*.sh
/opt/demoenv/setup.sh

echo "          "
echo "Copy Fortify SSC init.token: "
cat 01-fortify-ssc/init.token && echo

echo "          "
#echo "***INFO! Cleaning up Docker System"
echo "          "

#docker system prune -a -f
#docker system prune

echo "          "
echo "Finished"
echo "          "
