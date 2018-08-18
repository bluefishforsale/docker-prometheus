#!/usr/bin/env bash

SERVICE="prometheus"
IMAGE="prom/prometheus"
VERSION="latest"
LOCALDIR="/data01"

docker stop ${SERVICE}
docker rm ${SERVICE}

sudo docker run -d \
  -p 9090:9090 \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  -e PUID=1001 -e PGID=1001 \
  -v ${LOCALDIR}/services/${SERVICE}:/data \
  ${IMAGE}:${VERSION} \
    --config.file=/data/prometheus.yml
