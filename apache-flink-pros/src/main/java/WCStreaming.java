import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.util.Collector;

public class WCStreaming {
    public static void main(String[] args) throws Exception {
        //构建Stream环境
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        //读取端口流数据
        DataStreamSource<String> ds = env.socketTextStream("localhost", 9999);
        //flatMap -> keyBy -> timeWindow -> sum
        DataStream<WordCount> resultDataStream = ds.flatMap(new FlatMapFunction<String, WordCount>() {
            @Override
            public void flatMap(String line, Collector<WordCount> collector) throws Exception {
                for(String s : line.split(" ")){
                    collector.collect(new WordCount(s,1));
                }
            }
        })
                //由于使用了自定义类型有字段名 可以使用字段名聚合
                .keyBy("word")
                //窗口大小和滑动步长没有倍数约束，由于flink是实时数据流，不像spark受限于离散的rdd
                .timeWindow(Time.seconds(5), Time.seconds(2))
                //最后按照聚合的key数量叠加
                .sum("count");

        //输出
        resultDataStream.print();
        //需要手动触发
        env.execute();
    }



    //使用类接收单词计数
    public static class WordCount{
        //注意字段必须声明为public
        public String word;
        public Integer count;

        //注意要有空参构造
        public WordCount(){}

        public WordCount(String word, Integer count) {
            this.word = word;
            this.count = count;
        }

        @Override
        public String toString() {
            return "WordCount{" +
                    "word='" + word + '\'' +
                    ", count=" + count +
                    '}';
        }
    }

    public static class WordWithCount{
        public String word;
        public long count;
        public WordWithCount(){}
        public WordWithCount(String word , long count){
            this.word = word;
            this.count = count;
        }

        public String toString(){
            return "WordWithCount{" +
                    "word='" + word + '\'' +
                    ", count=" + count +
                    '}';
        }
    }
}
