#!/bin/bash

#rabbitport=`kubectl get svc -n feeder| grep broker|awk -F '15672:' '{print $2}'|cut -c 1-5`
rabbitport=`kubectl get svc -n feeder| grep rabbitmq| grep LoadBalancer|awk -F '15672:' '{print $2}'|cut -c 1-5`
mysqlhost=`kubectl get svc -n feeder|grep mysql|awk '{ print $3}'`

processed=$(mysql -u root -h $mysqlhost -pmypass -s -N -e "select count(distinct(text)) from ingress.ingress"|sed 's/\r//')
inyected=$(curl -i -u guest:guest http://localhost:$rabbitport/api/queues/%2f/hello -s |sed 's/,/\n/g' | grep '"publish"' | sed 's/"publish"://g')
#processed=$(mysql -u root -h $mysqlhost -pmypass -s -N -e "select count(1) from ingress.ingress"|sed 's/\r//')


echo "$processed"
echo "$inyected"
echo "scale=5; $processed/$inyected*100" | bc
