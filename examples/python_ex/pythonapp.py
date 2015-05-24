"""A simple Spark app in Python"""
from pyspark import SparkContext

sc = SparkContext("local[2]", "First Spark App")

data = sc.textFile("user_purchase_history.csv") \
    .map(lambda line: line.split(",")) \
    .map(lambda record: (record[0], record[1], record[2]))

num_purchases = data.count()
unique_users = data.map(lambda record: record[0]).distinct().count()
total_revenue = data.map(lambda record: float(record[2])).sum()
products = data.map(lambda record: (record[1], 1.0)).reduceByKey(
  lambda a, b: a + b).collect()
most_popular = sorted(products, key=lambda x: x[1], reverse=True)[0]

print "Total purchases: %d" % num_purchases
print "Unique users: %d" % unique_users
print "Total_revenue: %d" % total_revenue
print "Most most_popular: %s" % most_popular[0]

