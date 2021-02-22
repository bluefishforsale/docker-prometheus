#!/usr/bin/env bash

SERVICE="blackbox"
IMAGE="prom/blackbox-exporter"
VERSION="master"
LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${SERVICE}


sudo docker run -d \
  -p 9115:9115 \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  -v ${LOCALDIR}/config:/config \
  ${IMAGE}:${VERSION} \
    --config.file=/config/blackbox.yml
