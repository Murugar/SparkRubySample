require 'ruby-spark'

# Configuration
Spark.config do
   set_app_name "RubySpark"
   set 'spark.ruby.serializer', 'oj'
   set 'spark.ruby.serializer.batch_size', 100
end

# Start Apache Spark
Spark.start




ser = Spark::Serializer.build('batched(marshal, 10)')

# Range 0..100, 2 workers, custom serializer
rdd = Spark.sc.parallelize(0..100, 2, ser)


# Take first 5 items
rdd.take(5)
# => [0, 1, 2, 3, 4]


# Numbers reducing
rdd.reduce(lambda{|sum, x| sum+x})
rdd.reduce(:+)
rdd.sum
# => 5050


# Reducing with zero items
seq = lambda{|x,y| x+y}
com = lambda{|x,y| x*y}
rdd.aggregate(1, seq, com)
# 1. Every workers adds numbers
#    => [1226, 3826]
# 2. Results are multiplied
#    => 4690676


# Statistic method
rdd.stats
# => StatCounter: (count, mean, max, min, variance,
#                  sample_variance, stdev, sample_stdev)


# Compute a histogram using the provided buckets.
rdd.histogram(2)
# => [[0.0, 50.0, 100], [50, 51]]


# Mapping
rdd.map(lambda {|x| x*2}).collect
# => [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, ...]
rdd.map(:to_f).collect
# => [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, ...]


# Mapping the whole collection
rdd.map_partitions(lambda{|part| part.reduce(:+)}).collect
# => [1225, 3825]


# Selecting
rdd.filter(lambda{|x| x.even?}).collect
# => [0, 2, 4, 6, 8, 10, 12, 14, 16, ...]


# Sampling
rdd.sample(true, 10).collect
# => [3, 36, 40, 54, 58, 82, 86, 95, 98]


# Sampling X items
rdd.take_sample(true, 10)
# => [53, 87, 71, 74, 18, 75, 55, 94, 46, 32]


# Using external process
rdd.pipe('cat', "awk '{print $1*10}'")
# => ["0", "10", "20", "30", "40", "50", ...]

