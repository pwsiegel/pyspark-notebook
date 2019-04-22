#!/bin/bash
set -eou pipefail

cluster="$1"
port="$2"
agent=${3:-}
master=$(flintrock describe "$cluster" | grep master | awk '{ print $NF }' | tr -d "\n")

if [[ -z "$agent" ]]; then
    ssh -L "$port":localhost:"$port" ec2-user@"$master"
else
    if [ "$agent" == "--agent" ]; then
        ssh -L -A "$port":localhost:"$port" ec2-user@"$master"
    else
        echo "Illegal argument $agent; the third argument can only be the flag --agent to enable agent forwarding"
        exit 1
    fi
fi
