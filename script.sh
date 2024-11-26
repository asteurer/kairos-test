#!/bin/bash

# set -o errexit

IMAGE_NAME=ghcr.io/asteurer/kairos-test:0.0.1

export USER=$(op item get kairos-items --vault Dev --fields label=username --reveal)
export PASSWORD=$(op item get kairos-items --vault Dev --fields label=password --reveal)
export IP_ADDR=$(op item get kairos-items --vault Dev --fields label=ip_address --reveal)

echo "generating the template..."

# Fill the template with data
go run generate_kairos_template.go

head -n 5 90_custom.yaml

docker build . -t $IMAGE_NAME

# Delete the filled template
rm 90_custom.yaml

docker login ghcr.io
docker push $IMAGE_NAME

echo "upgrading the image..."

ssh -T $USER@$IP_ADDR "sudo sh -c 'kairos-agent upgrade --source oci:$IMAGE_NAME'"