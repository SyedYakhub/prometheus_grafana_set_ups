#!/bin/bash

#Install helm using script
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
# helm version

#Install prometheus and grafana using helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl patch service prometheus-kube-prometheus-prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl patch service prometheus-grafana -p '{"spec": {"type": "NodePort"}}'
kubectl patch service prometheus-kube-prometheus-alertmanager -p '{"spec": {"type": "NodePort"}}'
kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode

#curl command to validate prometheus
#curl http://<ClusterIP>:9090/metrics

#Alternatively you can also edit service and change type=NodePort using below command
#kubectl edit svc prometheus-server

#Else you can expose extra svc with the below details
#kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext

# The command will output the base64 encoded password. Use base64 --decode to decode it and reveal the admin password.
# Once you have the admin password, you can access the Grafana web interface using the NodePort or LoadBalancer IP exposed by the Grafana service and log in with the "admin" username and the password obtained from the previous step.

# Here's an example of how the command would look like:

# kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode