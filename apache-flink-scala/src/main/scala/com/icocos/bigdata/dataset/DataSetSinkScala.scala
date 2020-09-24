package com.icocos.bigdata.dataset

import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.api.scala._
import org.apache.flink.core.fs.FileSystem.WriteMode

object DataSetSinkScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    writeAsText(env)
  }


  def writeAsText(env: ExecutionEnvironment): Unit = {
    val data = 1.to(10)
    val text = env.fromCollection(data)
    val path = "/Users/iCocos/Desktop/BigData/SuperBigData/.output/sink-scala/"
    text.writeAsText(path,WriteMode.OVERWRITE).setParallelism(2)
    env.execute("执行Sink")
  }


}
