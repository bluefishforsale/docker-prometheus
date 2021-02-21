#!/usr/bin/env bash

#SERVICE="nvidia-smi-exporter"
SERVICE="nvidia-smi-exporter"
#IMAGE="nvidia-smi-exporter"
IMAGE="nvcr.io/nvidia/k8s/dcgm-exporter"
VERSION="2.0.13-2.1.2-ubuntu18.04"
#VERSION="latest"
LOCALDIR="/data01/services/${SERVICE}"

docker rm -f ${SERVICE}

# docker run --rm --privileged -p 9454:9454 nvidia-smi-exporter

sudo docker run -d \
  -p 9400:9400 \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  --runtime=nvidia \
  --gpus=all \
  --cap-add SYS_ADMIN \
  --device /dev/dri:/dev/dri \
  ${IMAGE}:${VERSION}
