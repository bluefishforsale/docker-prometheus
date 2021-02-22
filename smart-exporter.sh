#!/usr/bin/env bash

SERVICE="smart-exporter"
IMAGE="antilax3/smart-exporter"
VERSION="latest"
LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${SERVICE}

#    --config.file=/config/blackbox.yml

sudo docker run -d \
  -p 9120:9120 \
  --restart=always \
  --name=${SERVICE} \
  --privileged=true \
  -e PUID=1001 -e PGID=1001 \
  --hostname=${HOSTNAME} \
  -v ${LOCALDIR}/config:/config \
  ${IMAGE}:${VERSION}
