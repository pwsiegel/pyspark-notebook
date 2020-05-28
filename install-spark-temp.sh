#!/bin/bash
set -eou pipefail

# Install Java
sudo yum install -y java-1.8.0-openjdk-devel

echo "# Java" >> "$HOME"/.bashrc
echo "export JAVA_HOME=\"$(dirname $(dirname $(readlink -f $(which javac))))\"" >> "$HOME"/.bashrc
echo "" >> "$HOME"/.bashrc

# Install Maven
wget "https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz" -P /tmp
sudo tar -xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt

echo "# Maven" >> "$HOME"/.bashrc
echo 'export M2_HOME=/opt/apache-maven-3.6.3' >> "$HOME"/.bashrc
echo 'export MAVEN_HOME=/opt/apache-maven-3.6.3' >> "$HOME"/.bashrc
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> "$HOME"/.bashrc
echo "" >> "$HOME"/.bashrc

# Install Spark
wget https://mirrors.gigenet.com/apache/spark/spark-2.4.5/spark-2.4.5.tgz -P /tmp
sudo tar -zxf /tmp/spark-2.4.5.tgz -C /opt
cd /opt/spark-2.4.5
build/mvn -Pyarn -Phadoop-3.1 -Pscala-2.12 -Dhadoop.version=3.1.2 -DskipTests clean package

echo "# Spark" >> "$HOME"/.bashrc
echo 'export SPARK_HOME=/opt/spark-2.4.5' >> "$HOME"/.bashrc
echo 'export PATH="$PATH:$SPARK_HOME/bin"' >> "$HOME"/.bashrc
echo "" >> "$HOME"/.bashrc
