#!/bin/bash 

if [ ! -d /repos ]; then mkdir /repos; fi
if [ ! -d /var/lib/mysql/mysql ]; then
    cp -r /default-data/mysql-data/* /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
fi

service mysql start
service apache2 start

/opt/phabricator/bin/config set phabricator.base-uri $BASE_URI
/opt/phabricator/bin/storage upgrade --force 
/opt/phabricator/bin/phd start

while [ 1 ]; do
    sleep 10000
done

