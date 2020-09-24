package com.icocos.bigdata.datastream

import org.apache.flink.api.scala.ExecutionEnvironment

object DataStreamSinkScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    sinkFunction(env)
  }

  def sinkFunction(env: ExecutionEnvironment): Unit = {

  }

}
