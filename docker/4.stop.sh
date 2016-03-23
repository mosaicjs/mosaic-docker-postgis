#!/bin/bash
cd `dirname $0`
dbdock=`cat ../.config/db.dock`
sudo docker stop $dbdock

