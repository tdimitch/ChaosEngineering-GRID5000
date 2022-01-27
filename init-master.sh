#!/bin/bash


sleep=$1
rm -f finished.lock 

source init-sw.sh

outFile="workers-join-to-master.sh"

IPADDR=`hostname |nslookup|grep Address|tail -n1|cut -c 10-`
export IPADDR

# Disable swap, mandatory to install k8s
# sudo sed -i '/swap/d' /etc/fstab
# sudo swapoff -a

kubeadm init --apiserver-advertise-address $IPADDR 

KUBE_JOIN=`kubeadm token create --print-join-command`

echo $KUBE_JOIN > $outFile
chmod +x $outFile
echo "TOKEN wrote to $outFile"


export KUBECONFIG=/etc/kubernetes/admin.conf

cp /etc/kubernetes/admin.conf .
echo "export KUBECONFIG=`pwd`/admin.conf" > env.sh

./docker-images.sh

nNodes=`kubectl get node|grep -v NAME|wc -l` 
echo -n "Waiting for nodes to join (currently: $nNodes)"
while [ $nNodes -lt 3 ]
do
  nNodes2=`kubectl get node|grep -v NAME|wc -l` 
  if [ $nNodes != $nNodes2 ]
  then 
	  nNodes=$nNodes2
	  echo -n $nNodes
  fi
  echo -n "."
  sleep 1
done
echo " .. OK"

echo "Launching deployments.."
./deploy.sh $IPADDR

touch finished.lock

sleep $sleep
