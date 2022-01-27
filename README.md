# ChaosEngineering-GRID5000
Automatic deployment of a Kubernetes Cluster in GRID5000

Execute:
./crea_cluster.sh
Parameters:
    • sleep - active g5k node instance time, 1h by default
    • number of workers - workers added to the cluster, 4 by default (plus máster)
Approximately, expect 7 minutes for cluster creation.


    a) Infrastructure and general tools

    • weave net
    • nginx ingress controller
    • longhorn storage
    • kubernetes dashboard
    • prometheus y grafana

    b) Testing components

    • clúster mariadb (4 nodos)
    • clúster rabbitmq (4 nodos)

    c) Additionally

    • chaos mesh
    
After cluster creation, the following info will be printed:
    a) parameters to create ssh tunnels:
    • dashboard kubernetes (localhost: 8881)
    • longhorn dashboard (localhost: 8882)
    • grafana interface (localhost: 8883)
    • rabbitmq admin interface (localhost: 8884)
    • chaos mesh admin interface (localhost: 8885)
    b) Prometheus url (IP) to manually configure grafana
    c) Kubernetes dashboard token
    

MANUAL CONFIGURATIONS:
a) Manual initialization: 

From any worker set mariadb & rabbitmq config, before deploying feeder and consumer statefulsets (load first KUBEADMN env variable) using:
./termina.sh
which deploys two statefulsets:

    • feeder (2 instancias)
    • consumer (2 instancias)
    


b) Grafana configuration:

    • access grafana (http://localhost:8883)
    • credentials (admin/admin)
    • Configure Prometheus datasource:
configuration -> datasources -> add datasource -> type prometheus -> URL (returned by crea_cluster.sh or by kubectl describe pod prometheus-server-* -n prometheus IP) -> save & test
    • Load k8s dashboard:
dashboards -> manage -> import -> 315 (grafana.com id) -> load -> select prometheus datasource -> import
