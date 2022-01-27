#!/bin/bash

if [ $# -lt 1 ]; then
    echo $0": script requires 1 argument"
    exit -1
fi
echo -n "Reserving node "
JOB=$(oarsub "$1" |grep OAR_JOB_ID |cut -c 12-)
if [[ $JOB == '' ]]
then
	echo $0": oarsub did not return a JOB id" 
	exit -1
else
	T=0
	IPADDR=''
	while [[ $IPADDR == '' ]] && [[ $T -le 20 ]]
        do
		IPADDR=$(oarstat -j $JOB -f |grep assigned_hostnames | cut -c 25- |nslookup |grep Address| tail -n1 |cut -c 10-)
		T=$[$T+1]
		sleep 1
		echo -n .
	done
	echo
	if [[ $IPADDR == '' ]]
	then
		echo $0": cannot get node ip"
		exit -1
	else
		echo Reserved with IP: $IPADDR and init script $1
		exit 1
	fi
fi

