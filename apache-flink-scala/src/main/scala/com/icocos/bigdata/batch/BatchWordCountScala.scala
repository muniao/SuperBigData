package com.icocos.bigdata.batch

import org.apache.flink.api.scala.ExecutionEnvironment

object BatchWordCountScala {

  def main(args: Array[String]): Unit = {

    // 1. 获取上下文
    val env = ExecutionEnvironment.getExecutionEnvironment;

    // 2. 读入数据
    val input = "/Users/iCocos/Desktop/BigData/SuperBigData/ApacheFlink/src/main/resources/input";
    val text = env.readTextFile(input);

    // 导入隐式转换
    import org.apache.flink.api.scala._

    // 3. 转换操作
    text.flatMap(_.toLowerCase.split("\t"))
        .filter(_.nonEmpty)
        .map((_,1))
        .groupBy(0)
        .sum(1)
        .print();

    // 打印
    text.print();

  }

}
