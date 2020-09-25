package com.icocos.bigdata.datastream

import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment

object DataStreamSinkScala {

  def main(args: Array[String]): Unit = {

    // 1. 获取上下文
    val env = StreamExecutionEnvironment.getExecutionEnvironment;
    sinkFunction(env)
    env.execute
  }

  def sinkFunction(env: StreamExecutionEnvironment): Unit = {

  }

}
