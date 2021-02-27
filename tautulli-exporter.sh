#!/usr/bin/env bash

SERVICE="tautulli-exporter"
IMAGE="tubaguy50035/tautulli_exporter"
VERSION="latest"
TAUTULLI_URI="http://ocean.local/tautulli"
TAUTULLI_API_KEY="11c4a8c245984a6cb2b96414cac61923"

docker rm -f ${SERVICE}

sudo docker run -d \
  -p 8913:9487 \
  --dns 192.168.1.1 \
  --dns-search local \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  -e TAUTULLI_API_KEY="${TAUTULLI_API_KEY}" \
  -e TAUTULLI_URI="${TAUTULLI_URI}" \
  -e TAUTULLI_TIMEOUT=60 \
  ${IMAGE}:${VERSION}
