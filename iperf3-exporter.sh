#!/usr/bin/env bash

SERVICE="speedtest-cli-exporter"
IMAGE="bluefishforsale/speedtest-cli-exporter"
VERSION="latest"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9119:9119 \
  --dns 192.168.1.1 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  ${IMAGE}:${VERSION} \
    --servers terrac.com \
    --parallel 10 \
    --omit_secs 2 \
    --test_time 10 \
    --interval 30
