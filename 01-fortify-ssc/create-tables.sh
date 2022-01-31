#!/bin/bash

mysql --host=localhost -u root -pM1cro_F0cus -e "create database ssc CHARACTER SET latin1 COLLATE latin1_general_cs;"

mysql --host=localhost -u root -pM1cro_F0cus ssc < /home/mysql/create-tables.sql