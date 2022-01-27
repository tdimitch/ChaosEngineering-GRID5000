#!/bin/bash

USER=ladmin
PASSWORD=ladmin

echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth

{
kubectl create namespace longhorn-system

kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

cd yamls && kubectl apply -f .

go=`kubectl get storageclass | grep longhorn| wc -l`
while [ $go -lt 1 ]
do
	sleep 1
	go=`kubectl get storageclass | grep longhorn| wc -l`
done
sleep 5
kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

pod=`kubectl get pod -n longhorn-system| grep ui| awk '{print $1}'`
kubectl expose pod $pod --type=NodePort --name=longhorn-dashboard -n longhorn-system
} 2>&1 > registro.log



port=`kubectl -n longhorn-system get svc| grep longhorn-dashboard |awk '{ print $5}'|awk -F ":" '{print $2}'|cut -c 1-5`

echo " URL del dashboard de longhorn -> http://$1:$port" | tee -a registro.log

