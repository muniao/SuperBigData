package com.icocos.bigdata.dataset

import org.apache.flink.api.common.functions.FlatMapFunction
import org.apache.flink.api.common.operators.Order
import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.api.scala._

import scala.collection.mutable.ListBuffer

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
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
    data.mapPartition( in => in map( _ + 1)).print()
  }

  /**
   * first
   */
  def firstFunction(env: ExecutionEnvironment) {
    val data = env.fromCollection(List(1,2,3,4,5,6,7,8,9))
    data.first(3).print()
    //data.groupBy(0).first(2).print()
    //data.groupBy(0).sortGroup(1,Order.ASCENDING).first(2).print()
  }

  /**
   * flatmap
   */
  def flatmapFunction(env: ExecutionEnvironment) {
    val info = ListBuffer[String]()
    info.append("iCocos,name");
    info.append("s,name");
    info.append("iCocos,s");
    val data = env.fromCollection(info)
    data.map(_.split(",")).print()
    data.flatMap(_.split(",")).print()
    data.flatMap(_.split(",")).map((_,1)).groupBy(0).sum(1).print()
  }

  /**
   * distinct
   */
  def distinctFunction(env: ExecutionEnvironment) {
    val info = ListBuffer[String]()
    info.append(",name");
    info.append("s,");
    info.append(",s");

    val data = env.fromCollection(info)
    data.flatMap(_.split(",")).distinct().print()
  }

  /**
   * join
   */
  def joinFunction(env: ExecutionEnvironment) {
    val info1 = ListBuffer[(Int,String)]()
    info1.append((1,",name"));
    info1.append((2,"s,"));
    info1.append((3,",s"));

    val info2 = ListBuffer[(Int,String)]()
    info2.append((1,"iCocos,"));
    info2.append((2,",name"));
    info2.append((5,"iCocos"));

    val data1 = env.fromCollection(info1)
    val data2 = env.fromCollection(info2)
    data1.join(data2).where(0).equalTo(0).apply((x,y) => {
      (x._1,x._2,y._2)
    }).print()
  }

  /**
   * outerjoin
   */
  def outerjoinFunction(env: ExecutionEnvironment) {
    val info1 = ListBuffer[(Int,String)]()
    info1.append((1,",name"));
    info1.append((2,"s,"));
    info1.append((3,",s"));

    val info2 = ListBuffer[(Int,String)]()
    info2.append((1,"iCocos,"));
    info2.append((2,",name"));
    info2.append((5,"iCocos"));

    val data1 = env.fromCollection(info1)
    val data2 = env.fromCollection(info2)
    data1.leftOuterJoin(data2).where(0).equalTo(0).apply((x,y) => {
      if (y == null) {
        (x._1,x._2,null)
      } else {
        (x._1,x._2,y._2)
      }
    }).print()
  }

  /**
   * cross
   */
  def crossFunction(env: ExecutionEnvironment) {
    val info1 = ListBuffer[(Int,String)]()
    info1.append((1,",name"));
    info1.append((2,"s,"));
    info1.append((3,",s"));

    val info2 = ListBuffer[(Int,String)]()
    info2.append((1,"iCocos,"));
    info2.append((2,",name"));
    info2.append((5,"iCocos"));

    val data1 = env.fromCollection(info1)
    val data2 = env.fromCollection(info2)
    data1.cross(data2).print()
  }

}
