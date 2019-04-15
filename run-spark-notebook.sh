#!/bin/bash

export PORT=8888

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="lab --no-browser --port=$PORT"

pyspark --packages "org.apache.hadoop:hadoop-aws:3.1.0" \
        --master spark://"$(hostname -I | tr -d ' ')":7077 \
