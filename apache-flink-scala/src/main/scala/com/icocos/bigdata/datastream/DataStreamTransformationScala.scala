package com.icocos.bigdata.datastream

import org.apache.flink.api.scala.ExecutionEnvironment

object DataStreamTransformationScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    mapFunction(env);
    filterFunction(env);
    unionFunction(env);
    splitFunction(env);
  }

  def mapFunction(env: ExecutionEnvironment): Unit = {

  }

  def filterFunction(env: ExecutionEnvironment): Unit = {

  }

  def unionFunction(env: ExecutionEnvironment): Unit = {

  }

  def splitFunction(env: ExecutionEnvironment): Unit = {

  }

}
