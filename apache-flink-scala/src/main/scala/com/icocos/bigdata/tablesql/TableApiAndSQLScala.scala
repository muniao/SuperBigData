package com.icocos.bigdata.tablesql

import org.apache.flink.api.scala.ExecutionEnvironment
import org.apache.flink.table.api.scala.BatchTableEnvironment
import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment
import org.apache.flink.table.api.scala.StreamTableEnvironment
import org.apache.flink.table.api.{EnvironmentSettings, TableEnvironment}
import org.apache.flink.api.scala._
import org.apache.flink.types.Row

object TableApiAndSQLScala {

//  // **********************
//  // FLINK STREAMING QUERY
//  // **********************
//  import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment
//  import org.apache.flink.table.api.EnvironmentSettings
//  import org.apache.flink.table.api.scala.StreamTableEnvironment
//
//  val fsSettings = EnvironmentSettings.newInstance().useOldPlanner().inStreamingMode().build()
//  val fsEnv = StreamExecutionEnvironment.getExecutionEnvironment
//  val fsTableEnv = StreamTableEnvironment.create(fsEnv, fsSettings)
//  // or val fsTableEnv = TableEnvironment.create(fsSettings)
//
//  // ******************
//  // FLINK BATCH QUERY
//  // ******************
//  import org.apache.flink.api.scala.ExecutionEnvironment
//  import org.apache.flink.table.api.scala.BatchTableEnvironment
//
//  val fbEnv = ExecutionEnvironment.getExecutionEnvironment
//  val fbTableEnv = BatchTableEnvironment.create(fbEnv)
//
//  // **********************
//  // BLINK STREAMING QUERY
//  // **********************
//  import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment
//  import org.apache.flink.table.api.EnvironmentSettings
//  import org.apache.flink.table.api.scala.StreamTableEnvironment
//
//  val bsEnv = StreamExecutionEnvironment.getExecutionEnvironment
//  val bsSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inStreamingMode().build()
//  val bsTableEnv = StreamTableEnvironment.create(bsEnv, bsSettings)
//  // or val bsTableEnv = TableEnvironment.create(bsSettings)
//
//  // ******************
//  // BLINK BATCH QUERY
//  // ******************
//  import org.apache.flink.table.api.{EnvironmentSettings, TableEnvironment}
//
//  val bbSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inBatchMode().build()
//  val bbTableEnv = TableEnvironment.create(bbSettings)

  //https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/table/common.html
  def main(args: Array[String]): Unit = {
    val batchEnv1 = ExecutionEnvironment.getExecutionEnvironment
    batchTableFunction1(batchEnv1)
    val streamEnv1 = StreamExecutionEnvironment.getExecutionEnvironment
    streamTableFunction1(streamEnv1)
    val batchEnv2 = ExecutionEnvironment.getExecutionEnvironment
    batchTableFunction2(batchEnv2)
    val streamEnv2 = StreamExecutionEnvironment.getExecutionEnvironment
    streamTableFunction2(streamEnv2)
  }

  def batchTableFunction1(env: ExecutionEnvironment): Unit = {
    val fbEnv = ExecutionEnvironment.getExecutionEnvironment
    val fbTableEnv = BatchTableEnvironment.create(fbEnv)

    val filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.csv"
    val csv = env.readCsvFile[UserInfoData](filePath,ignoreFirstLine=true)
    //csv.print()

    val userInfo = fbTableEnv.fromDataSet(csv)
    fbTableEnv.registerTable("user_info",userInfo)
    val results = fbTableEnv.sqlQuery("select create_time,count(*) from user_info group by create_time")
    fbTableEnv.toDataSet[Row](results).print()
  }

  def streamTableFunction1(env: StreamExecutionEnvironment): Unit = {
//    val fsSettings = EnvironmentSettings.newInstance().useOldPlanner().inStreamingMode().build()
//    val fsEnv = StreamExecutionEnvironment.getExecutionEnvironment
//    val fsTableEnv = StreamTableEnvironment.create(fsEnv, fsSettings)
//    // or val fsTableEnv = TableEnvironment.create(fsSettings)
  }


  def batchTableFunction2(env: ExecutionEnvironment): Unit = {
//    val bbSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inBatchMode().build()
//    val bbTableEnv = TableEnvironment.create(bbSettings)
  }

  def streamTableFunction2(env: StreamExecutionEnvironment): Unit = {
//    val bsEnv = StreamExecutionEnvironment.getExecutionEnvironment
//    val bsSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inStreamingMode().build()
//    val bsTableEnv = StreamTableEnvironment.create(bsEnv, bsSettings)
//    // or val bsTableEnv = TableEnvironment.create(bsSettings)
  }

  case class UserInfoData(user_id: String,
                          create_time: String,
                          name: String,
                          mobile: String)

}
