require 'ruby-spark'

# Configuration
Spark.config do
   set_app_name "RubySpark"
   set 'spark.ruby.serializer', 'oj'
   set 'spark.ruby.serializer.batch_size', 100
end

# Start Apache Spark
Spark.start




# Context reference

rdd = Spark.sc.parallelize([10_000], 1)
rdd = rdd.add_library('bigdecimal/math')
rdd = rdd.map(lambda{|x| BigMath.PI(x)})
rdd.collect # => #<BigDecimal, '0.31415926...'>
