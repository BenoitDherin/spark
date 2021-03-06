# Installing Spark

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

```bash
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
```bash
>MASTER=local[2] ./bin/run-example org.apache.spark.examples.SparkPi
```
A Spark cluster is made up of two types of processes: a driver program and multiple executors. In the local mode, all these processes are run within the same JVM. In a cluster, these processes are usually run on separate nodes
if we run the code on a Spark standalone cluster, we could simply pass in the URL for the master node as follows:

```bash
>MASTER=spark://IP:PORT ./bin/run-example org.apache.spark.examples.SparkPi
```
* http://spark.apache.org/docs/latest/cluster-overview.html
* http://spark.apache.org/docs/latest/submitting-applications.html

# The SparkContext object and the Spark shells

* Spark Quick Start: http://spark.apache.org/docs/latest/quick-start.html
* Spark Programming guide, which covers Scala, Java, and Python: http://spark.apache.org/docs/latest/programming-guide.html

The starting point of writing any Spark program is SparkContext (or JavaSparkContext in Java). SparkContext is initialized with an instance of a SparkConf object, which contains various Spark cluster-configuration settings (for example, the URL of the master node).

Once initialized, we will use the various methods found in the SparkContext object to create and manipulate distributed datasets and shared variables. 

```scala
val conf = new SparkConf()
.setAppName("Test Spark App")
.setMaster("local[4]")
val sc = new SparkContext(conf) 
```

 If we wish to use default configuration values, we could also call the following simple constructor for our SparkContext object, which works in exactly the same way:

```scala
val sc = new SparkContext("local[4]", "Test Spark App")
```
To use the Spark shell with Scala, simply run 

```bash
./bin/spark-shell
```

from the Spark base directory. This will launch the Scala shell and initialize SparkContext, which is available to us as the Scala value, sc.

To use the Python shell with Spark, simply run the 

```bash
./bin/pyspark
```

command. Like the Scala shell, the Python SparkContext object should be available as the Python variable sc. 

# Resilient Distributed Dataset (RDD)

The core of Spark is a concept called the Resilient Distributed Dataset (RDD). An RDD is a collection of "records" (strictly speaking, objects of some type) that is distributed or partitioned across many nodes in a cluster (for the purposes of the Spark local mode, the single multithreaded process can be thought of in the same way). An RDD in Spark is fault-tolerant; this means that if a given node or task fails (for some reason other than erroneous user code, such as hardware failure, loss of communication, and so on), the RDD can be reconstructed automatically on the remaining nodes and the job will still complete.

```
val collection = List("a", "b", "c", "d", "e")
val rddFromCollection = sc.parallelize(collection)
```

RDDs can also be created from Hadoop-based input sources, including the local filesystem, HDFS, and Amazon S3. A Hadoop-based RDD can utilize any input format that implements the Hadoop InputFormat interface, including text files, other standard Hadoop formats, HBase, Cassandra, and many more. The following code is an example of creating an RDD from a text file located on the local filesystem:

```scala
val rddFromTextFile = sc.textFile("LICENSE")
Spark operations
```

# Spark Transformations and Actions

Once we have created an RDD, we have a distributed collection of records that we can manipulate. In Spark's programming model, operations are split into 

* transformation: i.e., an operation that applies some function to all the records in the dataset, changing the records in some way. Example:

```scala
val intsFromStringsRDD = rddFromTextFile.map(line => line.size)
```
 
* action: i.e., an operation that runs some computation or aggregation operation and returns the result to the driver program where SparkContext is running. Example:

```scala
val sumOfRecords = intsFromStringsRDD.sum
val numRecords = intsFromStringsRDD.count
val aveLengthOfRecord = sumOfRecords / numRecords
```

* http://spark.apache.org/docs/latest/programming-guide.html#rdd-operations
* http://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.RDD

# Caching RDDS

```scala
rddFromTextFile.cache
```

Calling cache on an RDD tells Spark that the RDD should be kept in memory. 

```scala
val aveLengthOfRecordChained = rddFromTextFile.map(line => line.size).sum / rddFromTextFile.count
```
 # Broadcast variables and accumulators
 
 A broadcast variable is a read-only variable that is made available from the driver program that runs the SparkContext object to the nodes that will execute the computation. 

```scala
val broadcastAList = sc.broadcast(List("a", "b", "c", "d", "e"))
sc.parallelize(List("1", "2", "3")).map(x => broadcastAList.value ++ x).collect
```
The `collect` method is a Spark action that returns the entire RDD to the driver as a Scala (or Python or Java) collection. (Beware that for large datasets this may transform the driver node into a bottle neck, or crash memory). 
