import findspark
from pyspark.sql import SparkSession
import boto3
import os

findspark.init()


def aws_creds(profile=None):
    try:
        credentials = (
            boto3.Session(profile_name=profile)
            .get_credentials()
            .get_frozen_credentials()
        )
    except:
        print("AWS credentials not found")
        raise
    return {"access_key": credentials.access_key, "secret_key": credentials.secret_key}


def default_spark_session(name, master, access_key=None, secret_key=None):
    builder = (
        SparkSession.builder.master(master)
        .appName(name)
        .config("spark.driver.maxResultSize", "4G")
        .config("spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version", "2")
    )
    if access_key and secret_key:
        builder = (
            builder.config("fs.s3.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
            .config("fs.s3a.access.key", access_key)
            .config("fs.s3a.secret.key", secret_key)
        )
    return builder.getOrCreate()
