#!/bin/bash

cd `dirname $0`
dbdock=`cat ../.config/db.dock`
dbhost=`cat ../.config/db.host`
dbport=`cat ../.config/db.port`
dbuser=`cat ../.config/db.user`
dbpass=`cat ../.config/db.pass`
dbname=`cat ../.config/db.name`

echo "* dbdock=$dbdock"
echo "* dbhost=$dbhost"
echo "* dbport=$dbport"
echo "* dbuser=$dbuser"
echo "* dbpass=$dbpass"
echo "* dbname=$dbname"

