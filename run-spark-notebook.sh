#!/bin/bash

export PORT=8888
export DRIVER_MEMORY=30G
export EXECUTOR_MEMORY=220G

export PYSPARK_SUBMIT_ARGS="--packages org.apache.hadoop:hadoop-aws:3.1.0 pyspark-shell"
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="lab --no-browser --port=$PORT"

pyspark --packages "org.apache.hadoop:hadoop-aws:3.1.0" \
        --master spark://"$(hostname -I | tr -d ' ')":7077 \
		--executor-memory "$EXECUTOR_MEMORY" \
        --driver-memory "$DRIVER_MEMORY" \
