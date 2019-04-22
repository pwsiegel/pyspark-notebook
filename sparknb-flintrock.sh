#!/bin/bash
set -eou pipefail

cluster="$1"
port="$2"
master=$(flintrock describe "$cluster" | grep master | awk '{ print $NF }' | tr -d "\n")

if [ -z "$3" ]; then
    if [ "$3" = "agent" ]; then
        ssh -L -T "$port":localhost:"$port" ec2-user@"$master"
    else
        exit 1
    fi
else
    ssh -L "$port":localhost:"$port" ec2-user@"$master"
fi
