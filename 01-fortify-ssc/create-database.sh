#!/bin/bash
# Create MySQL database using fortify-ssc:/tools/fortify/sql/mysql/create-tables.sql
mkdir -p mysql/

docker cp fortify-ssc:/tools/fortify/sql/mysql/ .

docker cp mysql/ fortify-mysql:/home/

docker cp create-tables.sh fortify-mysql:/home/mysql/

docker exec fortify-mysql chmod a+x /home/mysql/create-tables.sh 

docker exec fortify-mysql /home/mysql/create-tables.sh 
