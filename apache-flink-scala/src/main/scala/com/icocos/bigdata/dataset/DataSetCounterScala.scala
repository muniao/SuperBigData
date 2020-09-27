package com.icocos.bigdata.dataset

import org.apache.flink.api.common.functions.RichMapFunction
import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.api.scala._
import org.apache.flink.configuration.Configuration
import org.apache.flink.api.common.accumulators.LongCounter
import org.apache.flink.core.fs.FileSystem.WriteMode

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
object DataSetCounterScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    counterFunction(env)
  }

  def counterFunction(env: ExecutionEnvironment): Unit = {
    val text = env.fromElements("111","222","333","444","555")
    val info = text.map(new RichMapFunction[String,Long]() {
      // 定义计数器
      val counter = new LongCounter()
      override def open(parameters: Configuration): Unit = {
        // 注册计数器
        getRuntimeContext.addAccumulator("ele-counts-scala",counter)
      }
      override def map(value: String): Long = {
        counter.add(1)
        value.toLong
      }
    }).setParallelism(3)

    val path = "/Users/iCocos/Desktop/BigData/SuperBigData/.output/sink-scala/"
    info.writeAsText(path,WriteMode.OVERWRITE).setParallelism(2)
    val job = env.execute("执行Counter")
    // 获取计数器
    val num = job.getAccumulatorResult[Long]("ele-counts-scala")
    println(num)
  }

}

