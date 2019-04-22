#!/bin/bash
set -eou pipefail

export PORT="$1"
export DRIVER_MEMORY=30G
export EXECUTOR_MEMORY=220G
export MAX_RESULTS_SIZE=4G

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="lab --no-browser --port=$PORT"

pyspark --packages "org.apache.hadoop:hadoop-aws:3.1.0" \
        --master spark://"$(hostname -I | tr -d ' ')":7077 \
        --executor-memory "$EXECUTOR_MEMORY" \
        --driver-memory "$DRIVER_MEMORY" \
        --conf spark.driver.maxResultSize="$MAX_RESULTS_SIZE" \
        --conf spark.hadoop.fs.s3a.connection.maximum=1000 \
        --conf spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version=2
