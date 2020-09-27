package com.icocos.bigdata.datastream;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
public class DataStreamSinkJava {

    public static void main(String[] args) throws Exception {
        // 1. 获取上下文
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        sinkFunction(env);
        env.execute();
    }

    // practical-pros/src/main/java/flink/kafka/mysql
    public static void sinkFunction(StreamExecutionEnvironment env) throws Exception {

    }

}
