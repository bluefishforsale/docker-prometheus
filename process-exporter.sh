#!/usr/bin/env bash

SERVICE="process-exporter"
IMAGE="ncabatoff/process-exporter"
VERSION="latest"

docker rm -f ${SERVICE}


sudo docker run -d \
  -p 9256:9256 \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  --privileged \
  -v /proc:/host/proc \
  -v ${LOCALDIR}/config:/config \
  ${IMAGE}:${VERSION}
