import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.tuple.Tuple2;

public class WCBatch {
    public static void main(String[] args) throws Exception {
        //获取flink运行环境 坑：需要flink_clients客户端
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        //读取数据源 读取集合数据fromElements 读取本地文件readTextFile 实际返回类型是DataSource是DataSet抽象类子类
        DataSet<String> ds = env.fromElements("Who's there?",
                "I think I hear them. Stand, ho! Who's there?");
//        env.readTextFile("");
        //计算 flatMap -> groupBy -> sum
        //优化new FlatMapFuntion(...)为lambda表达式
        DataSet<Tuple2<String,Integer>> result = ds.flatMap((FlatMapFunction<String, Tuple2<String, Integer>>) (line, collector) -> {
            for(String s : line.split(" ")){
                collector.collect(new Tuple2<>(s, 1));
            }
        })
                .groupBy(0)
                .sum(1);
        //输出由于自带execute不需要手动触发
        result.print();
    }
}
