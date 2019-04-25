#!/bin/bash
set -eou pipefail

cluster=${1:?Usage: ./setup-sparknb.sh <flintrock-cluster-name> <port-number>}
port=${2:?Usage: ./setup-sparknb.sh <flintrock-cluster-name> <port-number>}
master=$(flintrock describe "$cluster" | grep master | awk '{ print $NF }' | tr -d "\n")

ssh -L "$port":localhost:"$port" ec2-user@"$master"
