#!/usr/bin/env bash

SERVICE="ndt-exporter"
IMAGE="bluefishforsale/ndt-speedtest-exporter"
VERSION="latest"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9140:9140 \
  --dns 192.168.1.2 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  ${IMAGE}:${VERSION}
