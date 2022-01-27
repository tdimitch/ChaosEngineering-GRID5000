#!/bin/bash

( cd yamls && kubectl apply -f . ) 2>&1 > regitro.log

# ya crea un svc bajo balancer, accesible con puerto alto en la ip del master
# configurar el datasource con el svc del server de prometeus
# importar de grafana.com el dashboard 315 (hay que hacerle dos correcciones en el widget de cpu para que pinte)

port=`kubectl -n prometheus get svc| grep grafana|awk '{ print $5}'|awk -F ":" '{print $2}'|cut -c 1-5`


echo "URL para grafana -> https://$1:$port (admin:admin)" | tee -a registro.log
