#!/bin/bash 

#
# MySQL
#
cd /var/lib/mysql; 
if [ ! -d mysql ]; then 
    cp -r /default-data/mysql-data/* .
fi
chown -R mysql:mysql /var/lib/mysql
service mysql start
service apache2 start

#
# elasticsearch
#
sudo -u elasticsearch /opt/elasticsearch-1.7.3/bin/elasticsearch -d

#
# Configuration of phabircator
#
cd /opt/phabricator/conf/local
if [ ! -e local.json ]; then
    cp /default-data/phabricator-conf-local/* .
fi

/opt/phabricator/bin/config set phabricator.base-uri $BASE_URI
/opt/phabricator/bin/storage upgrade --force 
/opt/phabricator/bin/phd start

if [ ! -d /opt/elasticsearch-1.7.3/data ]; then
    /opt/phabricator/bin/search init
    /opt/phabricator/bin/search index --all
else
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-1.7.3/data
fi

#
# storage
#
chown -R www-data:www-data /storage

#
# Git
#
if [ ! -d /repos ]; then mkdir /repos; fi
if [ ! -d /var/run/sshd ]; then mkdir /var/run/sshd; fi
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator

while [ 1 ]; do
    sleep 10000
done

