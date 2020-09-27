package com.icocos.bigdata.datastream

import org.apache.flink.api.common.state.{ListState, ListStateDescriptor}
import org.apache.flink.runtime.state.{FunctionInitializationContext, FunctionSnapshotContext}
import org.apache.flink.streaming.api.checkpoint.CheckpointedFunction
import org.apache.flink.streaming.api.functions.source.SourceFunction
import org.apache.flink.streaming.api.scala.StreamExecutionEnvironment
import org.apache.flink.streaming.api.windowing.time.Time

import org.apache.flink.api.scala._

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
object DataStreamSourceScala {

  def main(args: Array[String]): Unit = {

    // 1. 获取上下文
    val env = StreamExecutionEnvironment.getExecutionEnvironment;
    sourcefunctionFunction(env)
    parallelsourcefunctionFunction(env)
    richparallelsourcefunctionFunction(env)
    env.execute
  }

  // Socket
  def flinkStreamingFunction(env: StreamExecutionEnvironment): Unit = {
    val text = env.socketTextStream("localhost", 9999)

    val counts = text.flatMap { _.toLowerCase.split("\\W+") filter { _.nonEmpty } }
      .map { (_, 1) }
      .keyBy(0)
      .timeWindow(Time.seconds(5))
      .sum(1)

    counts.print().setParallelism(3)

    env.execute("Window Stream WordCount")
  }

  //-----------------StreamExecutionEnvironment.addSource(sourceFunction)----------------------
  // apache-flink-java/src/main/java/com/icocos/bigdata/datastream/DataStreamSourceJava.java

  // 自定义数据源一: 非并行 -> SourceFunction
  def sourcefunctionFunction(env: StreamExecutionEnvironment): Unit = {

  }

  // 自定义数据源二: 并行 -> ParallelSourceFunction
  def parallelsourcefunctionFunction(env: StreamExecutionEnvironment): Unit = {

  }

  // 自定义数据源三: 增强并行 -> RichParallelSourceFunction
  def richparallelsourcefunctionFunction(env: StreamExecutionEnvironment): Unit = {

  }

  //-----------------StreamExecutionEnvironment.addSource(sourceFunction)----------------------
  class ExampleCountSource extends SourceFunction[Long] with CheckpointedFunction {
    private var count: Long = 0L
    private var isRunning: Boolean = true
    private var checkpointedCount: ListState[Long] = null

    @throws[Exception]
    override def run(ctx: SourceFunction.SourceContext[Long]): Unit = {
      while ( {
        isRunning && count < 1000
      }) {
        ctx.getCheckpointLock synchronized ctx.collect(count)
        count += 1

      }
    }

    override def cancel(): Unit = {
      isRunning = false
    }

    @throws[Exception]
    override def initializeState(context: FunctionInitializationContext): Unit = {
      this.checkpointedCount = context.getOperatorStateStore.getListState(new ListStateDescriptor[Long]("count", classOf[Long]))
      if (context.isRestored) {
        import scala.collection.JavaConversions._
        for (count <- this.checkpointedCount.get) {
          this.count = count
        }
      }
    }

    @throws[Exception]
    override def snapshotState(context: FunctionSnapshotContext): Unit = {
      this.checkpointedCount.clear()
      this.checkpointedCount.add(count)
    }
  }

}
