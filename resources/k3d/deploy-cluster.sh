#!/bin/bash
#
# Creates k3d clusters
#
#

create_cluster(){
    for i in $(seq 1 "$1"); do 
        cluster_name="cluster$i"
        echo "Creating cluster with name $cluster_name"
        K3D_CREATE_COMMAND="k3d cluster create $cluster_name"
        eval $K3D_CREATE_COMMAND
    done

    echo "=================================="
    echo ""
    echo "List of K3D clusters: "
    echo ""
    eval "k3d cluster list"
    echo ""
    echo "=================================="
}

#########################
# main

CLUSTER_COUNT=${1:-2}

create_cluster $CLUSTER_COUNT
