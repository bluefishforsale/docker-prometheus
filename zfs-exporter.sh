#!/usr/bin/env bash

SERVICE="zfs-exporter"
IMAGE="derekgottlieb/zfs-exporter"
VERSION="latest"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9150:9254 \
  --privileged \
  --dns 192.168.1.2 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  ${IMAGE}:${VERSION}
