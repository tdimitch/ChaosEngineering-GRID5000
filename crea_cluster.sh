#!/bin/bash

inicio=`date +%s`
sleep=1h

# SERIOUS WARN: script not tested
#               changes in deployment install scripts not tested!!!

# INSTRUCTIONS: execute as $0 | tee -a cluster.info
# WARN: each execution regenerates cluster.info
> cluster.info

# INSTRUCTIONS: cluster may grow adding additional workers: 
#               ./crea_instancia.sh "sudo-g5k init-workers.sh
# TODO: for previous action work after 24h join token must be 
#       regenerated (non sense in g5k)

# TODO: translate comments and script names! (ouch)

# TODO: manage nWorkers from command line
nWorkers=9

# TODO: manage 'beta' deploys from command line

# MAIN

# - master creation
rm -f workers-join-to-master.sh

MASTER=$( ./crea_instancia.sh "sudo-g5k ./init-master.sh $sleep" | grep IP | awk '{print $4 }' )
echo "Provisioned master as $MASTER"

echo -n "Waiting to master to be ready... "
while [ ! -f workers-join-to-master.sh ]
do
  echo -n "."
  sleep 1
done

echo

# - workers creation
for i in `seq 1 $nWorkers`
do
	WORKER=$( ./crea_instancia.sh "sudo-g5k ./init-workers.sh $sleep" | grep IP | awk '{print $4 }' )
	echo "Provisioned worker as $WORKER"
done

# - deployments
# it is not going to work this way.. implement waits on creation of master and launch inside init-master once nodes are available
#JOB=`oarstat | grep lapuerta|head -1|awk '{print $1}'`
#oarsub -C $JOB "sudo-g5k ./deploy.sh"

echo -n "Waiting for deploys... "
while [ ! -f finished.lock ]
do
	echo -n "."
	sleep 1
done
echo

echo "Useful info"
echo "----------------------"
echo -n "tunnel cmd: "
p=8881
OAR=`oarstat | grep lapuerta|head -1 |awk '{print $1}'`
for i in `grep URL OAR.${OAR}.stdout|grep http |awk -F ":" '{print $2":"$3}' |sed 's|//||g'|awk '{print $1}'`
do 
	echo -n "-L $p:"$i" "
	let p=$p+1
done
echo
echo "dashboard token: "
grep TOKEN deploys/03-dashboard/registro.log


echo -n "Time spent (seconds): "
fin=`date +%s`
echo "$fin - $inicio"| bc

