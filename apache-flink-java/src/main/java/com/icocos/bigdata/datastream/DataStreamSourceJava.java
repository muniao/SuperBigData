package com.icocos.bigdata.datastream;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.state.ListState;
import org.apache.flink.api.common.state.ListStateDescriptor;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.runtime.state.FunctionInitializationContext;
import org.apache.flink.runtime.state.FunctionSnapshotContext;
import org.apache.flink.streaming.api.checkpoint.CheckpointedFunction;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.source.SourceFunction;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.util.Collector;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
public class DataStreamSourceJava {

    public static void main(String[] args) throws Exception {

        // 1. 获取上下文
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        sourcefunctionFunction(env);
        parallelsourcefunctionFunction(env);
        richparallelsourcefunctionFunction(env);
        env.execute();
    }

    // Socket
    public static void flinkStreamingFunction(StreamExecutionEnvironment env) throws Exception {
        DataStream<Tuple2<String, Integer>> dataStream = env
                .socketTextStream("localhost", 9999)
                .flatMap(new Splitter())
                .keyBy(0)
                .timeWindow(Time.seconds(5))
                .sum(1);

        dataStream.print().setParallelism(3);

        env.execute("Window WordCount");
    }

    public static class Splitter implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String sentence, Collector<Tuple2<String, Integer>> out) throws Exception {
            for (String word: sentence.split(" ")) {
                out.collect(new Tuple2<String, Integer>(word, 1));
            }
        }
    }

    //-----------------StreamExecutionEnvironment.addSource(sourceFunction)----------------------

    // 自定义数据源一: 非并行 -> SourceFunction
    public static void sourcefunctionFunction(StreamExecutionEnvironment env) throws Exception {

    }

    // 自定义数据源二: 并行 -> ParallelSourceFunction
    public static void parallelsourcefunctionFunction(StreamExecutionEnvironment env) throws Exception {

    }

    // 自定义数据源三: 增强并行 -> RichParallelSourceFunction
    public static void richparallelsourcefunctionFunction(StreamExecutionEnvironment env) throws Exception {

    }

    //-----------------StreamExecutionEnvironment.addSource(sourceFunction)----------------------

    public class ExampleCountSource implements SourceFunction<Long>, CheckpointedFunction {
        private long count = 0L;
        private volatile boolean isRunning = true;

        private transient ListState<Long> checkpointedCount;

        @Override
        public void run(SourceContext<Long> ctx) throws Exception {
            while (isRunning && count < 1000) {
                synchronized (ctx.getCheckpointLock()) {
                    ctx.collect(count);
                    count++;
                }
            }
        }

        @Override
        public void cancel() {
            isRunning = false;
        }

        @Override
        public void initializeState(FunctionInitializationContext context) throws Exception {
            this.checkpointedCount = context
                    .getOperatorStateStore()
                    .getListState(new ListStateDescriptor<>("count", Long.class));

            if (context.isRestored()) {
                for (Long count : this.checkpointedCount.get()) {
                    this.count = count;
                }
            }
        }

        @Override
        public void snapshotState(FunctionSnapshotContext context) throws Exception {
            this.checkpointedCount.clear();
            this.checkpointedCount.add(count);
        }
    }

}
