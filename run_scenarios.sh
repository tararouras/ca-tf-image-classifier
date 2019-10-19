#!/bin/bash

set -e

function clear_deployment()
{
	flvr=$1
	dpl_tp=$2

	echo "clearing deployment of scenario $dpl_tp-$flvr"

	kubectl delete -f edge-server-hpa-$dpl_tp-$flvr.yaml || return 1
	sleep 2
	kubectl delete -f edge-server-service.yaml || return 1
	sleep 2
	kubectl delete -f edge-server-deployment-$flvr.yaml || return 1
	sleep 2
}

function deploy_scenario()
{
	flvr=$1
	dpl_tp=$2

	echo "deploying scenario $dpl_tp-$flvr"

	kubectl create -f edge-server-deployment-$flvr.yaml || return 1
	sleep 2
	kubectl create -f edge-server-service.yaml || return 1
	sleep 2
	kubectl create -f edge-server-hpa-$dpl_tp-$flvr.yaml || return 1
	sleep 2
}

function run_scenario()
{
	flvr=$1
	dpl_tp=$2

	echo "executing scenario $dpl_tp-$flvr"

	deploy_scenario $flvr $dpl_tp || return 1
	sleep 30

	echo "starting warm-up for 5 minutes"
	docker run --rm -d --name edge-server-client -e EDGE_SERVER_IP_ADDR=192.168.0.140 -e EDGE_SERVER_PORT=30800 -v /home/akouris/Documents/kubernetes_and_metrics/ca-tf-image-classifier/intervals:/tmp/intervals --privileged edge-server-tf-client:latest
	sleep 300
	docker rm -f edge-server-client
	echo "done warming up, will now wait for 4 minutes"
	sleep 240

	echo "now executing scenario $flvr for $dpl_tp .."
	docker run --rm -it -e EDGE_SERVER_IP_ADDR=192.168.0.140 -e EDGE_SERVER_PORT=30800 -v /home/akouris/Documents/kubernetes_and_metrics/ca-tf-image-classifier/intervals:/tmp/intervals --privileged edge-server-tf-client:latest
	echo "execution done, sleep for 10 minutes and then clean up"
	sleep 600


	clear_deployment $flvr $dpl_tp || return 1
	echo "cleanup done, sleep for 2 minutes and then continue"
	sleep 120
}

echo "starting execution"
echo

for flavor in small big
do
	for depl_type in custom cpu
	do
		run_scenario $flavor $depl_type || exit 1
	done
done

echo
echo "finished execution"
