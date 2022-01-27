#!/bin/bash

# Possibly install krew and  RabbitMQ Cluster Operator Plugin for kubectl 
# https://www.rabbitmq.com/kubernetes/operator/kubectl-plugin.html
# Need krew
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/#bash

# or directly Install the RabbitMQ Cluster Operator
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

# Monitor via Prometheus operator
# https://www.rabbitmq.com/kubernetes/operator/operator-monitoring.html

# Create a RabbitMQ Instance 
( cd yamls && kubectl apply -f . ) 2>&1 > regitro.log
kubectl get all -l app.kubernetes.io/name=rabbitmq-system


