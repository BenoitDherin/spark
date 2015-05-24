# spark

* http://spark.apache.org/docs/latest/ 
* http://spark.apache.org/downloads.html
* http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.4.tgz

Spark needs to be built against a specific version of Hadoop in order to access Hadoop Distributed File System (HDFS) as well as standard and custom Hadoop input sources.

Spark requires 

* the Scala programming language
* Java Runtime Environment (JRE)

>tar xfvz spark-1.2.0-bin-hadoop2.4.tgz
>cd spark-1.2.0-bin-hadoop2.4
>./bin/run-example org.apache.spark.examples.SparkPi

This will run the example in Spark's local standalone mode.

…
14/11/27 20:58:47 INFO SparkContext: Job finished: reduce at SparkPi.scala:35, took 0.723269 s
Pi is roughly 3.1465
…

To configure the level of parallelism in the local mode, you can pass in a master parameter of the local[N] form, where N is the number of threads to use. For example, to use only two threads, run the following command instead:

>MASTER=local[2] ./bin/run-example org.apache.spark.examples.SparkPi
