package com.icocos.bigdata.dataset

import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.configuration.Configuration

object DataSetSourceScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    fromCollection(env)
    fromTextFile(env)
    fromCSVFile(env)
    fromResvFile(env)
    fromZipFile(env)
  }

  /**
   * 从集合创建
   */
  def fromCollection(env: ExecutionEnvironment): Unit = {
    import org.apache.flink.api.scala._
    val data = 1 to 100
    env.fromCollection(data).print()
  }

  /**
   * 从文件创建：可指定文件夹直接读取
   */
  def fromTextFile(env: ExecutionEnvironment): Unit = {
    val filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.txt"
    env.readTextFile(filePath).print()
  }

  /**
   * 从CSV文件创建
   */
  def fromCSVFile(env: ExecutionEnvironment): Unit = {
//    val filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.csv"
//    env.readCsvFile[(String,Int,String)](filePath,ignoreFirstLine=true).print()
//    env.readCsvFile[(String,Int)](filePath,ignoreFirstLine=true,includedFields = Array(0,1)).print()
//    // Case Class
//    case class MyCaseClass(name: String,age:Int)
//    env.readCsvFile[MyCaseClass](filePath,ignoreFirstLine=true,includedFields = Array(0,1)).print()
//    // POJO
//    env.readCsvFile[PojoPerson](filePath,ignoreFirstLine=true,pojoFields = Array("anme","age","work")).print()
  }

  /**
   * 从递归文件创建
   */
  def fromResvFile(env: ExecutionEnvironment): Unit = {
    val filePath = "/Users/iCocos/Desktop/BigData/SuperBigData"
    val parameters = new Configuration()
    parameters.setBoolean("recuresive.file.enumeration",true)
    env.readTextFile(filePath).withParameters(parameters).print()
  }

  /**
   * 从压缩文件创建
   */
  def fromZipFile(env: ExecutionEnvironment): Unit = {
    val filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.zip"
    env.readTextFile(filePath).print()
  }


}
