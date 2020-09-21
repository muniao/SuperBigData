#!/bin/bash

set -e

if [ "$1" == "" ]; then
    echo -e "\033[31mError: imageName is blank!\033[0m"
    exit 1
elif [ "$1" == "all" ]; then
    for imageName in `docker images | grep -v "REPOSITORY" | awk '{print $1":"$2}'`; do
        docker save $imageName > `echo $imageName | tr '/' '_' | tr ':' '_'`.tar
    done
else
    docker save $1 > `echo $1 | tr '/' '_' | tr ':' '_'`.tar
fi
