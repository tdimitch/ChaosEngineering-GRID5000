#!/bin/bash

MASTER=$1

kubectl exec -n feeder --tty --stdin rabbitmq-cluster-server-0 -- rabbitmqctl add_user guest guest
kubectl exec -n feeder --tty --stdin rabbitmq-cluster-server-0 -- rabbitmqctl set_permissions -p / guest ".*" ".*" ".*"
kubectl exec -n feeder --tty --stdin rabbitmq-cluster-server-0 -- rabbitmqctl set_user_tags guest administrator

kubectl exec -n feeder --tty --stdin rabbitmq-cluster-server-0 -- rabbitmqctl set_policy replicated "^hello$" '{"ha-mode":"all"}'

kubectl exec -n feeder --tty --stdin mariadb-0 -- mysql -u root -h localhost -e "create user 'root'@'%' identified by 'mypass'"
kubectl exec -n feeder --tty --stdin mariadb-0 -- mysql -u root -h localhost -e "create database ingress"
kubectl exec -n feeder --tty --stdin mariadb-0 -- mysql -u root -h localhost -e "GRANT ALL ON ingress.* to 'root'@'%'"
kubectl exec -n feeder --tty --stdin mariadb-0 -- mysql -u root -h localhost -e "CREATE TABLE ingress.ingress (id int(11) NOT NULL AUTO_INCREMENT,text varchar(10) NOT NULL,PRIMARY KEY (id)) ENGINE=InnoDB AUTO_INCREMENT=30711 DEFAULT CHARSET=utf8mb4"

cd deploys-beta/estressers
kubectl apply -f 10feeder-sf.yaml
kubectl apply -f 20consumer-sf.yaml
cd ../..

cd chaos
#kubectl apply -f .
cd ..

