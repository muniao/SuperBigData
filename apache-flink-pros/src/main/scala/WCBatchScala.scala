//to enable implicit conversion instead of creating implicit value for each type that you use.
//需要手动导包
import org.apache.flink.api.scala._
object WCBatchScala {
  def main(args: Array[String]): Unit = {
    val env = ExecutionEnvironment.getExecutionEnvironment
    val ds = env
      .fromElements("Who's there?","I think I hear them. Stand, ho! Who's there?")
      .flatMap(_.split(" "))
      .map((_,1))
      .groupBy(0)
      .sum(1)
    ds.print()

  }
}
