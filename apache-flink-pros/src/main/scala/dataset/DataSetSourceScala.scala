package dataset

import org.apache.flink.api.scala.ExecutionEnvironment

object DataSetSourceScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    //fromCollection(env)
    fromTextFile(env)
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

  }

  /**
   * 从递归文件创建
   */
  def fromResvFile(env: ExecutionEnvironment): Unit = {

  }

  /**
   * 从压缩文件创建
   */
  def fromZipFile(env: ExecutionEnvironment): Unit = {

  }


}
