#!/bin/bash

export kubever=$(kubectl version | base64 | tr -d '\n')
#wget "https://cloud.weave.works/k8s/net?k8s-version=$kubever" -o weave.yaml -q

#kubectl apply -f weave.yaml 2>&1 > registro.log
kubectl apply -f  "https://cloud.weave.works/k8s/net?k8s-version=$kubever" 2>&1 > registro.log

#echo "Instalado weave net." | tee -a registro.log
