#!/bin/bash

#Install helm using script
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
# helm version

#Install prometheus using helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl patch service prometheus-kube-prometheus-prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl patch service prometheus-grafana -p '{"spec": {"type": "NodePort"}}'

#Alternatively you can also edit service and change type=NodePort using below command
#kubectl edit svc prometheus-server

#Else you can expose extra svc with the below details
#kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext