#!/bin/bash
set -eou pipefail

port=${1:?Usage: ./run-sparknb.sh <port-number>}

DRIVER_MEMORY=4G
EXECUTOR_MEMORY=8G
MAX_RESULTS_SIZE=4G

export SPARK_HOME=${SPARK_HOME:-$HOME/spark}
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="lab --no-browser --notebook-dir=$HOME --port=$port"

pyspark --packages "org.apache.hadoop:hadoop-aws:3.1.0" \
        --master local[*] \
        --executor-memory "$EXECUTOR_MEMORY" \
        --driver-memory "$DRIVER_MEMORY" \
        --conf spark.driver.maxResultSize="$MAX_RESULTS_SIZE" \
        --conf spark.hadoop.fs.s3a.connection.maximum=1000 \
        --conf spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version=2
