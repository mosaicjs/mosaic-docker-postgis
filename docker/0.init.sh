#!/bin/bash

cd `dirname $0`
cd ..
dir=`pwd`
dbdock=`cat .config/db.dock`
dbhost=`cat .config/db.host`
dbport=`cat .config/db.port`
dbuser=`cat .config/db.user`
dbpass=`cat .config/db.pass`
dbname=`cat .config/db.name`

echo "Preparing the postgres image..."
sudo docker build -t postgis-plv8 $dir/docker

sudo docker run \
    -v $dir/.config:/db/.config:rw\
    -v $dir/data:/db/data:rw\
    -v $dir/docker/0.init:/docker-entrypoint-initdb.d\
    -e POSTGRES_USER=$dbuser\
    -e POSTGRES_PASSWORD=$dbpass\
    -e POSTGRES_DB=$dbname\
    -e PGDATA=/db/data/pgdata\
    --name $dbdock\
    -p $dbhost:$dbport:5432\
    -d postgis-plv8

echo "Done."
