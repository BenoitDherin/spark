#!/bin/bash 

APPNAME="lab"
APP_DIR=.

#  --------- PYTHON ENV
VENVNAME="${APPNAME}_env"
VENV_PATH=$APP_DIR/$VENVNAME
PIP_REQS_FILE="${APP_DIR}/pip_requirements.txt"

test -d $VENV_PATH || virtualenv $VENV_PATH || exit 1

{
  source ${VENV_PATH}/bin/activate &&
  ${VENV_PATH}/bin/pip install pip --upgrade &&
  ${VENV_PATH}/bin/pip install "ipython[notebook]" --upgrade &&
  ${VENV_PATH}/bin/pip install  -r ${PIP_REQS_FILE}  --upgrade 
} || exit 1

# --------- SPARK ENV
SPARK_HOME=/vagrant/spark/spark
SPARK_BINARIES="spark-1.3.1-bin-hadoop2.4"
SPARK_MIRROR="http://d3kbcqa49mib13.cloudfront.net"
SPARK_DIST="$SPARK_MIRROR/${SPARK_BINARIES}.tgz"

test -d $SPARK_HOME || 
  {
    wget -O - $SPARK_DIST | tar xzf - && 
    mv $SPARK_BINARIES $SPARK_HOME
  } || exit 1

# --------- JAVA 8 ENV 
# Following: http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt-get install oracle-java8-set-default

# --------- IPYTHON NOTEBOOK
# Following: http://blog.cloudera.com/blog/2014/08/how-to-use-ipython-notebook-with-apache-spark/
IPYTHON_CONFIG_DIR=~/.ipython/profile_${APPNAME}
IPYTHON_NB_CONFIG=${IPYTHON_CONFIG_DIR}/ipython_notebook_config.py

IPYTHON_STARTUP_DIR=${IPYTHON_CONFIG_DIR}/startup
IPYTHON_SPARK_STARTUP=${IPYTHON_STARTUP_DIR}/00-pyspark-setup.py

ipython profile create $APPNAME

cat > $IPYTHON_NB_CONFIG <<nb_config 
c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888 
nb_config

echo "$IPYTHON_SPARK_STARTUP"
cat > $IPYTHON_SPARK_STARTUP <<spark_startup
import os
import sys
spark_home = os.environ.get("SPARK_HOME", None)
if not spark_home:
  raise ValueError('SPARK_HOME environment variable is not set')
sys.path.insert(0, os.path.join(spark_home, 'python'))
sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.8.2.1-src.zip'))
execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))
spark_startup

# -------------- SCALA ENV 
# Following: https://gist.github.com/visenger/5496675
# sudo apt-get remove scala-library scala
# wget http://www.scala-lang.org/files/archive/scala-2.11.4.deb
# sudo dpkg -i scala-2.11.4.deb
# sudo apt-get update
# sudo apt-get install scala
# wget http://dl.bintray.com/sbt/debian/sbt-0.13.6.deb
# sudo dpkg -i sbt-0.13.6.deb 
# sudo apt-get update
# sudo apt-get install sbt
