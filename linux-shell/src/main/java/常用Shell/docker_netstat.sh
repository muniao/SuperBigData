#!/usr/bin/env bash

CONTAINER=$1

if [ ! ${CONTAINER} ]; then
    echo "CONTAINER is empty!"
    exit 1
fi

docker inspect --format '{{.State.Pid}} {{printf "%.13s" .ID}} {{.Name}}' ${CONTAINER} | \
while read CONTAINER_PID CONTAINER_ID CONTAINER_NAME; do
    echo ${CONTAINER_ID} ${CONTAINER_NAME} ${CONTAINER_PID}
    nsenter -t ${CONTAINER_PID} -n netstat -pan | grep ESTABLISHED
done
