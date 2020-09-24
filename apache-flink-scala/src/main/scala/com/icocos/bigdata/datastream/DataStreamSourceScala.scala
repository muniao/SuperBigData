package com.icocos.bigdata.datastream

import org.apache.flink.api.scala.ExecutionEnvironment

object DataStreamSourceScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    sourcefunctionFunction(env)
    parallelsourcefunctionFunction(env)
    richparallelsourcefunctionFunction(env)
    socketFunction(env)
  }

  def sourcefunctionFunction(env: ExecutionEnvironment): Unit = {

  }

  def parallelsourcefunctionFunction(env: ExecutionEnvironment): Unit = {

  }

  def richparallelsourcefunctionFunction(env: ExecutionEnvironment): Unit = {

  }

  def socketFunction(env: ExecutionEnvironment): Unit = {

  }

}
