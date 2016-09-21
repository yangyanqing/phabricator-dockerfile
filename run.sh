#!/bin/bash

base=/docker-data/phabricator
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
    -e "BASE_URI=http://pha.ccidnj.com/" \
    -p 22:22 \
    -p 80:80 \
    -v $base/repos:/repos \
    -v $base/mysql:/var/lib/mysql \
    -v $base/storage:/storage \
    -v $base/phabricator-conf-local:/opt/phabricator/conf/local \
    -v $base/elasticsearch-1.7.3-data:/opt/elasticsearch-1.7.3/data \
    phabricator:1.0

