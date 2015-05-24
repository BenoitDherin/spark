#!/bin/bash

SPARK_DIR=./spark
SPARK_BINARIES="spark-1.3.1-bin-hadoop2.4"
SPARK_MIRROR="http://d3kbcqa49mib13.cloudfront.net"
SPARK_DIST="$SPARK_MIRROR/${SPARK_BINARIES}.tgz"

test -d ${SPARK_DIST} || mkdir $SPARK_DIR
cd $SPARK_DIR && wget -O - $SPARK_DIST | tar xzf -

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default
