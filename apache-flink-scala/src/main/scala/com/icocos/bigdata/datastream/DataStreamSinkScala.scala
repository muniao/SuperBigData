package com.icocos.bigdata.datastream

import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
object DataStreamSinkScala {

  def main(args: Array[String]): Unit = {
    // 1. 获取上下文
    val env = StreamExecutionEnvironment.getExecutionEnvironment;
    sinkFunction(env)
    env.execute
  }

  // practical-pros/src/main/java/flink/kafka/mysql
  def sinkFunction(env: StreamExecutionEnvironment): Unit = {

  }

}
