# 启动 spark-submit 需要指定的参数
/root/apps/spark-2.3.0-bin-hadoop2.7/bin/spark-submit --master spark://test01:7077 --class cn.tiakon.spark.my.day01.ScalaWordCount /root/spark-learning-notes-and-demo-1.0-SNAPSHOT.jar hdfs://test01:9000/wordcount/input hdfs://test01:9000/wordcount/spark-scala-out
