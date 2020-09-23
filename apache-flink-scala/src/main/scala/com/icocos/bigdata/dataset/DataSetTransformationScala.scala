package com.icocos.bigdata.dataset

import org.apache.flink.api.scala.ExecutionEnvironment

import org.apache.flink.api.scala._

object DataSetTransformationScala {

  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
//    mapFunction(env)
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
    val data = env.fromCollection(List(1,2,3,4,5,6,7,8,9))
    data.map((x: Int) => x + 1).print()
    data.map((x) => x + 1).print()
    data.map(x => x + 1).print()
    data.map( _ + 1).print()
    data.map{ x => x + 1 }.print()
    data.map{ _ + 1 }.print()
  }

  /**
   * filter
   */
  def filterFunction(env: ExecutionEnvironment) {
    val data = env.fromCollection(List(1,2,3,4,5,6,7,8,9))
    data.map(_ + 1).filter( _ > 5).print()
  }

  /**
   * mappartition
   */
  def mappartitionFunction(env: ExecutionEnvironment) {
    val data = env.fromCollection(List(1,2,3,4,5,6,7,8,9))

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
