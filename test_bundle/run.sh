#!/bin/bash

set -ex

K3S_MANIFEST_DIR=${K3S_MANIFEST_DIR:-/var/lib/rancher/k3s/server/manifests/}

_check=$(kairos-agent config get "example.enable" | tr -d '\n')
if [ "$_check" == "true" ]; then
    echo "Hello, there!" > /home/kairos/hello.txt
    mkdir -p "${K3S_MANIFEST_DIR}"
    cp -rf assets/* "${K3S_MANIFEST_DIR}"
fi