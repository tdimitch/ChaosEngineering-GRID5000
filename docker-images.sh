#!/bin/bash

echo "Loading docker images.. "
cd dockers
for i in *.tar
do
  echo "Loading docker image $i"
  docker load -i $i
done
cd ..

bzcat feeder.tar.bz2 | docker load 
docker image tag feeder:latest feeder:thisone

bzcat processor.tar.bz2 | docker load 
docker image tag processor:latest processor:thisone

docker image tag rabbitmq:latest rabbitmq:thisone

docker image tag estressers:latest estressers:thisone

echo "Loaded images"
docker image ls
