#!/usr/bin/env bash

SERVICE="unifi-exporter"
IMAGE="jessestuart/unifi_exporter"
VERSION="v0.4.0"
LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9130:9130 \
  --dns 192.168.1.1 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  -v ${LOCALDIR}/config:/config \
  ${IMAGE}:${VERSION} \
    -config.file /config/config.yml
