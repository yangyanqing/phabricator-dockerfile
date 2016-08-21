#!/bin/bash 

if [ ! -d /repos ]; then mkdir /repos; fi

cd /var/lib/mysql; 
if [ ! -d mysql ]; then 
    cp -r /default-data/mysql-data/* .
    chown -R mysql:mysql /var/lib/mysql
fi

cd /opt/phabricator/conf/local
if [ ! -e local.json ]; then
    cp /default-data/phabricator-conf-local/* .
fi

service mysql start
service apache2 start

sudo -u elasticsearch /opt/elasticsearch-1.7.3/bin/elasticsearch -d

/opt/phabricator/bin/config set phabricator.base-uri $BASE_URI
/opt/phabricator/bin/storage upgrade --force 
/opt/phabricator/bin/phd start

if [ ! -d /opt/elasticsearch-1.7.3/data ]; then
    /opt/phabricator/bin/search init
    /opt/phabricator/bin/search index --all
fi

while [ 1 ]; do
    sleep 10000
done

