//同样需要手动导包用于隐式转换
import org.apache.flink.streaming.api.scala._
import org.apache.flink.streaming.api.windowing.time.Time

object WCStreamingScala {
  def main(args: Array[String]): Unit = {
    val env = StreamExecutionEnvironment.getExecutionEnvironment
    val resDS = env.socketTextStream("localhost",9999)
      .flatMap(_.split(" "))
      .map((_,1))
      .keyBy(0)
      .timeWindow(Time.seconds(5),Time.seconds(2))
      .sum(1)

    resDS.print()
    env.execute("WCStreamingScala")
  }
}
