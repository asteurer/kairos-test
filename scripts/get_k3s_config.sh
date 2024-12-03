#!/bin/bash

user=$1
ip_addr=$2
os=$3
config_name=$user-$os

ssh \
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	$user@$ip_addr \
    'sudo cat /etc/rancher/k3s/k3s.yaml' | LABEL=$config_name IP_ADDR=$ip_addr python3 ./scripts/edit_kubeconfig.py > ~/.kube/$config_name.config