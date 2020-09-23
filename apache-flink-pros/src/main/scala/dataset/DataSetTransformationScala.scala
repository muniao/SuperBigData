package dataset

import org.apache.flink.api.scala.ExecutionEnvironment

object DataSetTransformationScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    mapFunction(env)
    filterFunction(env)
    mappartitionFunction(env)
    firstFunction(env)
    flatmapFunction(env)
    distinctFunction(env)
    joinFunction(env)
    outerjoinFunction(env)
    crossFunction(env)
  }

  /**
   * map
   */
  def mapFunction(env: ExecutionEnvironment) {

  }

  /**
   * filter
   */
  def filterFunction(env: ExecutionEnvironment) {

  }

  /**
   * mappartition
   */
  def mappartitionFunction(env: ExecutionEnvironment) {

  }

  /**
   * first
   */
  def firstFunction(env: ExecutionEnvironment) {

  }

  /**
   * flatmap
   */
  def flatmapFunction(env: ExecutionEnvironment) {

  }

  /**
   * distinct
   */
  def distinctFunction(env: ExecutionEnvironment) {

  }

  /**
   * join
   */
  def joinFunction(env: ExecutionEnvironment) {

  }

  /**
   * outerjoin
   */
  def outerjoinFunction(env: ExecutionEnvironment) {

  }

  /**
   * cross
   */
  def crossFunction(env: ExecutionEnvironment) {

  }

}
