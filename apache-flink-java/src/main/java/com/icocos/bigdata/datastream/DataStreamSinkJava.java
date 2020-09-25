package com.icocos.bigdata.datastream;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

public class DataStreamSinkJava {
    public static void main(String[] args) throws Exception {

        // 1. 获取上下文
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        sinkFunction(env);
        env.execute();
    }

    public static void sinkFunction(StreamExecutionEnvironment env) throws Exception {

    }

}
