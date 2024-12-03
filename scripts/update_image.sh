#!/bin/bash

set -o errexit

IMAGE_NAME=ghcr.io/asteurer/kairos-test:0.0.2

export USER=$(op item get kairos-items --vault Dev --fields label=username --reveal)
export IP_ADDR=$(op item get kairos-items --vault Dev --fields label=ip_address --reveal)

docker build ./alter_server -t $IMAGE_NAME

docker login ghcr.io
docker push $IMAGE_NAME

ssh -T $USER@$IP_ADDR "sudo kairos-agent upgrade --source oci:$IMAGE_NAME"