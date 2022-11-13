#!/bin/sh


docker ps -a -q --filter ancestor=climapa-db | xargs docker stop
docker ps -a -q --filter ancestor=climapa-db | xargs docker rm
docker rmi climapa-db

. ./.env

docker build -t climapa-db .
docker run -d -p $MYSQL_PORT:$MYSQL_PORT -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD climapa-db
