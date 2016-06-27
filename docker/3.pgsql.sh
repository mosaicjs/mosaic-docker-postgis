#!/bin/bash

cd `dirname $0`
dbdock=`cat ../.config/db.dock`
dbhost=`cat ../.config/db.host`
dbport=`cat ../.config/db.port`
dbuser=`cat ../.config/db.user`
dbpass=`cat ../.config/db.pass`
dbname=`cat ../.config/db.name`

sudo docker run -it --link $dbdock:postgres --rm postgres sh -c "exec psql postgres://$dbuser:$dbpass@\$POSTGRES_PORT_5432_TCP_ADDR:\$POSTGRES_PORT_5432_TCP_PORT/$dbname" $@
 
