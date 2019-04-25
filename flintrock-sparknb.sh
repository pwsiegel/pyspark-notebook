#!/bin/bash
set -eou pipefail

cluster=${1:?Usage: ./setup-sparknb.sh <flintrock-cluster-name> <port-number>}
port=${2:?Usage: ./setup-sparknb.sh <flintrock-cluster-name> <port-number>}
master=$(flintrock describe "$cluster" --master-hostname-only)

ssh -L "$port":localhost:"$port" ec2-user@"$master"
