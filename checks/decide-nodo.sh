#!/bin/bash

dash=`kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces|grep  kubernetes-dashboa| awk '{print $1}'`

max=`kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name --all-namespaces|grep -v $dash|awk '{print $1}'|grep -v NODE| sort | uniq -c|head -1|awk '{print $2}'`

echo $max
