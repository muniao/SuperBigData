package com.icocos.bigdata.stream;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.util.Collector;

public class StreamWordCountJava {

    public static void main(String[] args) throws Exception {

        // 1. 获取上下文
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // 2. 读入数据
        // args.length != 2 && String hostName = args[0]; && Integer port = Integer.parseInt(args[1]);
        String host = "localhost";
        try {
            ParameterTool tool = ParameterTool.fromArgs(args);
            host = tool.get("host");
        } catch (Exception e) {
            System.err.println("域名或IP未设置，使用默认localhost");
        }
        int port = 9999;
        try {
            ParameterTool tool = ParameterTool.fromArgs(args);
            port = tool.getInt("port");
        } catch (Exception e) {
            System.err.println("端口未设置，使用默认端口9999");
        }
        DataStream<String> text = env.socketTextStream(host, port);

        // 3. 转换操作
        text.flatMap(new FlatMapFunction<String, Tuple2<String,Integer>>() {
            @Override
            public void flatMap(String s, Collector<Tuple2<String, Integer>> collector) {
                String[] tokens = s.toLowerCase().split("\\W+");
                for (String token: tokens) {
                    if (token.length() > 0) {
                        collector.collect(new Tuple2<String, Integer>(token, 1));
                    }
                }
            }
        }).keyBy(0).sum(1).print().setParallelism(1); // timeWindow(Time.seconds(5))

        // 4. 执行
        env.execute("Java WordCount from SocketTextStream Example");

    }

}