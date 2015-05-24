# spark

* http://spark.apache.org/docs/latest/ 
* http://spark.apache.org/downloads.html
* http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.4.tgz

Spark needs to be built against a specific version of Hadoop in order to access Hadoop Distributed File System (HDFS) as well as standard and custom Hadoop input sources:
```
Download Spark
The latest release of Spark is Spark 1.3.1, released on April 17, 2015 (release notes) (git tag)
Download Spark: spark-1.3.1-bin-hadoop2.4.tgz
Verify this release using the 1.3.1 signatures and checksums.
Note: Scala 2.11 users should download the Spark source package and build with Scala 2.11 support.
```
Spark requires 

* the Scala programming language
* Java Runtime Environment (JRE)

```
>tar xfvz spark-1.2.0-bin-hadoop2.4.tgz
>cd spark-1.2.0-bin-hadoop2.4
>./bin/run-example org.apache.spark.examples.SparkPi
```

This will run the example in Spark's local standalone mode.
```
…
14/11/27 20:58:47 INFO SparkContext: Job finished: reduce at SparkPi.scala:35, took 0.723269 s
Pi is roughly 3.1465
…
```
To configure the level of parallelism in the local mode, you can pass in a master parameter of the local[N] form, where N is the number of threads to use. For example, to use only two threads, run the following command instead:
```
>MASTER=local[2] ./bin/run-example org.apache.spark.examples.SparkPi
```
A Spark cluster is made up of two types of processes: a driver program and multiple executors. In the local mode, all these processes are run within the same JVM. In a cluster, these processes are usually run on separate nodes
if we run the code on a Spark standalone cluster, we could simply pass in the URL for the master node as follows:

```
>MASTER=spark://IP:PORT ./bin/run-example org.apache.spark.examples.SparkPi
```
* http://spark.apache.org/docs/latest/cluster-overview.html
* http://spark.apache.org/docs/latest/submitting-applications.html

# SparkContext object as well as the Spark shell

* Spark Quick Start: http://spark.apache.org/docs/latest/quick-start.html
* Spark Programming guide, which covers Scala, Java, and Python: http://spark.apache.org/docs/latest/programming-guide.html

The starting point of writing any Spark program is SparkContext (or JavaSparkContext in Java). SparkContext is initialized with an instance of a SparkConf object, which contains various Spark cluster-configuration settings (for example, the URL of the master node).

Once initialized, we will use the various methods found in the SparkContext object to create and manipulate distributed datasets and shared variables. 

```
val conf = new SparkConf()
.setAppName("Test Spark App")
.setMaster("local[4]")
val sc = new SparkContext(conf) 
```

 If we wish to use default configuration values, we could also call the following simple constructor for our SparkContext object, which works in exactly the same way:

```
val sc = new SparkContext("local[4]", "Test Spark App")
```
