#!/usr/bin/env bash

SERVICE="prometheus"
PROM="prometheus"
PROMIMAGE="prom/prometheus"
PROMVERSION="latest"

NODE="prom-node-exporter"
NODEIMAGE="prom/node-exporter"
NODEVERSION="latest"

LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${PROM} ${NODE}

# PROM
sudo docker run -d \
  -p 9090:9090 \
  --restart=always \
  --name=${PROM} \
  --hostname=${HOSTNAME} \
  -v ${LOCALDIR}/config:/config \
  -v ${LOCALDIR}/data:/prometheus/data \
  ${PROMIMAGE}:${PROMVERSION} \
    --config.file=/config/prometheus.yml \
    --log.level=debug


# NODE-EXPORTER
sudo docker run -d \
  --net=host \
  --pid=host \
  --restart=always \
  --name=${NODE} \
  --hostname=${HOSTNAME} \
  --cap-add SYS_ADMIN \
  --cap-add NET_ADMIN \
  -v "/:/host:ro,rslave" \
  --privileged \
  ${NODEIMAGE}:${NODEVERSION} \
    --log.level=debug \
    --path.rootfs=/host
