#!/bin/bash

sleep=$1

# Disable swap, mandatory to install k8s
# sudo sed -i '/swap/d' /etc/fstab
# sudo swapoff -a

source init-sw.sh

./docker-images.sh

./workers-join-to-master.sh

sleep $sleep
