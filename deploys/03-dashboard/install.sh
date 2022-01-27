#!/bin/bash

( cd yamls && kubectl apply -f . ) 2>&1 > registro.log

port=`kubectl -n kubernetes-dashboard get svc| grep kubernetes-dashboard|awk '{ print $5}'| cut -c 5-9`

echo " URL del dashboard de kubernetes -> https://$1:$port" | tee -a registro.log

./token.sh >> registro.log

