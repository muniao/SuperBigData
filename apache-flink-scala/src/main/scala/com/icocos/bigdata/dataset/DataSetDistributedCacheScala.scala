package com.icocos.bigdata.dataset

import org.apache.commons.io.FileUtils
import org.apache.flink.api.common.functions.{RichFunction, RichMapFunction}
import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.api.scala._
import org.apache.flink.configuration.Configuration

object DataSetDistributedCacheScala {
  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    distributedCacheFunction(env)
  }

  def distributedCacheFunction(env: ExecutionEnvironment): Unit = {
    val path = "/Users/iCocos/Desktop/BigData/SuperBigData/input.txt"

    // 注册分布式缓存
    env.registerCachedFile(path,"input-text-scala")

    val data = env.fromElements("111","222","333","444","555")
    data.map(new RichMapFunction[String,String] {
      override def open(parameters: Configuration): Unit = {
        // 获取分布式缓存内容
        val dFile = getRuntimeContext.getDistributedCache().getFile("input-text-scala")
        val lines = FileUtils.readLines(dFile)

        import scala.collection.JavaConverters._
        for(ele <- lines.asScala) {
          print(ele)
        }
      }
      override def map(value: String): String = {
        value
      }
    }).print()
  }
}
