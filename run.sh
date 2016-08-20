#!/bin/bash

base=/home/docker-volume/phabricator
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

docker run -d  --name pha\
    -e "BASE_URI=http://phabricator.yourcompony.com" \
    -p 80:80 \
    -v $base/data/repos:/repos \
    -v $base/data/mysql:/var/lib/mysql \
    pha

