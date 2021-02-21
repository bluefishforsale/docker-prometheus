#!/usr/bin/env bash

SERVICE="cadvisor"
IMAGE="gcr.io/cadvisor/cadvisor"
VERSION="latest"
LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${SERVICE}

# google/cadvisor
sudo docker run -d \
  -p 8912:8080 \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --privileged \
  --device=/dev/kmsg \
  ${IMAGE}:${VERSION}
