FROM quay.io/kairos/alpine:3.19-standard-amd64-generic-master-k3sv1.31.2-k3s1

RUN apk add --no-cache \
    helm

COPY 90_custom.yaml /oem/90_custom.yaml

WORKDIR /helm-charts
COPY helm_charts/demo ./demo