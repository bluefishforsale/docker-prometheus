#!/usr/bin/env bash

SERVICE="speedtest-cli-exporter"
IMAGE="bluefishforsale/speedtest-cli-exporter"
VERSION="latest"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9119:9119 \
  --dns 192.168.1.2 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  ${IMAGE}:${VERSION} \
    -s 27103 31420 5026 1783 \
    -p 9119 \
    -i 300
