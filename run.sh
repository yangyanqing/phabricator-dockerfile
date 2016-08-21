#!/bin/bash

base=/home/pha-data
repos=$base/repos
mysql=$base/mysql

function init_dir()
{
    dir=$1
    if [ ! -d $dir ]; then
        mkdir -p $dir
    fi
}

init_dir $repos
init_dir $mysql

docker run -d --name phabricator --restart=always \
    -e "BASE_URI=http://phabricator.yourcompony.com" \
    -p 80:80 \
    -v $base/repos:/repos \
    -v $base/mysql:/var/lib/mysql \
    -v $base/phabricator-conf-local:/opt/phabricator/conf/local \
    phabricator:tag

