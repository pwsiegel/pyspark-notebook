#!/bin/bash
set -eou pipefail

cluster="$1"
port="$2"
master=$(flintrock describe "$cluster" | grep master | awk '{ print $NF }' | tr -d "\n")

ssh -L "$port":localhost:"$port" ec2-user@"$master"
