#!/bin/bash


# Disable swap, mandatory to install k8s
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

apt-get update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
# Force the last 1.21.3-00 version of k8s, check apt-cache madison kubeadm for more
apt-get install -y kubelet=1.21.3-00 kubeadm=1.21.3-00 kubectl=1.21.3-00
apt-get install -y docker.io
apt-get install -y helm

systemctl enable docker.service

sysctl net.bridge.bridge-nf-call-iptables=1

#./docker-images.sh
