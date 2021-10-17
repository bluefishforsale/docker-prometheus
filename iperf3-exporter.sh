#!/usr/bin/env bash

SERVICE="iperf3-exporter"
IMAGE="bluefishforsale/iperf3-exporter"
VERSION="latest"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 9130:9130 \
  --dns 192.168.1.2 \
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
