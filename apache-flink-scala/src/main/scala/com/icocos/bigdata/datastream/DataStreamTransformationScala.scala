package com.icocos.bigdata.datastream

import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment

import org.apache.flink.api.scala._

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
object DataStreamTransformationScala {

  def main(args: Array[String]): Unit = {

    // 1. 获取上下文
    val env = StreamExecutionEnvironment.getExecutionEnvironment;
    mapFunction(env)
    filterFunction(env)
    unionFunction(env)
    splitFunction(env)
    selectFunction(env)
    env.execute
  }

  def mapFunction(env: StreamExecutionEnvironment): Unit = {
    val data = env.socketTextStream("localhost", 9999)
    data.map { x => x * 2 }
  }

  def filterFunction(env: StreamExecutionEnvironment): Unit = {
    val data = env.socketTextStream("localhost", 9999)
    data.filter { _ != 0 }
  }

  def unionFunction(env: StreamExecutionEnvironment): Unit = {
    val data1 = env.socketTextStream("localhost", 9999)
    val data2 = env.socketTextStream("localhost", 9999)
    val data3 = env.socketTextStream("localhost", 9999)
    data1.union(data2, data3)
  }

  def splitFunction(env: StreamExecutionEnvironment): Unit = {
//    val data = env.socketTextStream("localhost", 9999)
//    val split = data.split(
//      (num: Int) =>
//        (num % 2) match {
//          case 0 => List("even")
//          case 1 => List("odd")
//        }
//    )
  }

  def selectFunction(env: StreamExecutionEnvironment): Unit = {
//    val data = env.socketTextStream("localhost", 9999)
//    val even = split.select("even")
//    val odd = split.select("odd")
//    val all = split.select("even","odd")
  }

}
