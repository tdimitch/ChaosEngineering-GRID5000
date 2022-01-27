#!/bin/bash

{
./get_helm.sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl create namespace prometheus
helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.size=2Gi

# sacar el endpoint para configurar grafana (es el 'server')
# kubectl get svc --all-namespaces
} 2>&1 > registro.log

endpoint=`kubectl -n prometheus get svc| grep prometheus-server|awk '{ print $3}'`
echo "Endpoint/URL para configurar datasource en grafana -> $endpoint" | tee -a registro.log
