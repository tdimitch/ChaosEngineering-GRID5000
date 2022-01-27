#!/bin/bash

MASTER=$1

cd deploys

for folder in *
do
    echo -n "Deploying $folder.... "
    salida=$( cd $folder && ./install.sh $MASTER )
    if [ "X$salida" != "X" ]
    then
        echo " -> $salida"
    else
        echo
    fi
done
cd ..


cd deploys-beta

cd rabbitmq
./install.sh
cd ..


rabbitport=`kubectl get svc -n feeder| grep "rabbitmq"|grep LoadBalancer|awk -F '15672:' '{print $2}'|cut -c 1-5`

echo "URL rabbit -> http://$MASTER:$rabbitport"

cd ..

curl -sSL https://mirrors.chaos-mesh.org/v2.0.1/install.sh | bash
chaosport=`kubectl get svc -n chaos-testing | grep dashboard |awk -F '2333:' '{print $2}'|cut -c 1-5`

echo "URL chaos dashboard -> http://$MASTER:$chaosport"


#./termina.sh $MASTER
