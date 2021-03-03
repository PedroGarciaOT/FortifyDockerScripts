#!/bin/bash
# Setup COE in Linux
# Requires Docker to be up and running
# Requires dos2unix

echo "          "
echo "Starting"
echo "          "

docker volume create portainer_data

docker run --detach --hostname portainer --publish 9000:9000 --name portainer --restart always --volume /var/run/docker.sock:/var/run/docker.sock --volume portainer_data:/data portainer/portainer:latest

if [ ! -f "/opt/fortify/fortify.license" ]; then 
    mkdir -p /opt/fortify
    if [ -f "01-fortify-ssc/setup/FortifyInstallers/fortify.license" ]; then 
        cp 01-fortify-ssc/setup/FortifyInstallers/fortify.license /opt/fortify/
    else
        touch /opt/fortify/fortify.license
    fi
fi 

if [ ! -f "/opt/mysql/my.cnf" ]; then 
    mkdir -p /opt/mysql/config
    mkdir -p /opt/mysql/data
    if [ -f "01-fortify-ssc/setup/FortifyInstallers/my.cnf" ]; then 
        cp 01-fortify-ssc/setup/FortifyInstallers/my.cnf /opt/mysql/config/
    else
        touch /opt/mysql/config/my.cnf
    fi
fi

cd 00-fortify-centos8

docker build -t pedrogarciamf/fortify-centos:8 .

cd ../01-fortify-ssc

dos2unix *.sh
chmod a+x *.sh

./network.sh

docker run --detach --hostname fortify-mysql --publish 3306:3306 --publish 33060:33060 --name fortify-mysql --mount type=bind,src=/opt/mysql/config/my.cnf,dst=/etc/my.cnf --mount type=bind,src=/opt/mysql/data,dst=/var/lib/mysql --env MYSQL_ROOT_PASSWORD=M1cro_F0cus --env MYSQL_USER=microfocus --env MYSQL_PASSWORD=M1cro_F0cus --network=fortify-network --ip=172.50.0.10 mysql:8.0

sleep 60

docker run --detach --hostname mysql-admin --publish 9200:80 --name mysql-admin --env PMA_HOST=fortify-mysql --env PMA_PORT=3306 --env PMA_USER=root --env PMA_PASSWORD=M1cro_F0cus --env PMA_ARBITRARY=0 --env PMA_ABSOLUTE_URI=http://mysql-admin/ --network=fortify-network --ip=172.50.0.11   --add-host=fortify-mysql:172.50.0.10 phpmyadmin/phpmyadmin:latest

./flatten.sh

cd ../02-fortify-scancentral-sast

dos2unix *.sh
chmod a+x *.sh

./flatten.sh

cd ../03-fortify-sca

dos2unix *.sh
chmod a+x *.sh

./flatten.sh

cd ../

docker ps -a

docker images

echo "          "
echo "Copy Fortify SSC init.token: "
cat ./01-fortify-ssc/init.token && echo

echo "          "
echo "Press ENTER to start cleanup"
echo "          "

docker system prune -a -f

echo "          "
echo "Finished"
echo "          "