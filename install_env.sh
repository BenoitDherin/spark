#!/bin/bash

SPARK_DIR=./spark
SPARK_BINARIES="spark-1.3.1-bin-hadoop2.4"
SPARK_MIRROR="http://d3kbcqa49mib13.cloudfront.net"
SPARK_DIST="$SPARK_MIRROR/${SPARK_BINARIES}.tgz"

test -d $SPARK_DIR || 
  {
    wget -O - $SPARK_DIST | tar xzf - && 
    mv $SPARK_BINARIES $SPARK_DIR
  } || exit 0

# Installing Oracle jre 8
# Following: http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default

# Installing Scala
# https://gist.github.com/visenger/5496675
sudo apt-get remove scala-library scala
wget http://www.scala-lang.org/files/archive/scala-2.11.4.deb
sudo dpkg -i scala-2.11.4.deb
sudo apt-get update
sudo apt-get install scala

# Installing scala builder
# https://gist.github.com/visenger/5496675
wget http://dl.bintray.com/sbt/debian/sbt-0.13.6.deb
sudo dpkg -i sbt-0.13.6.deb 
sudo apt-get update
sudo apt-get install sbt
