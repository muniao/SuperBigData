package com.icocos.bigdata.datastream;

import org.apache.flink.api.java.ExecutionEnvironment;

public class DataStreamSinkJava {
    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        sinkFunction(env);
    }

    public static void sinkFunction(ExecutionEnvironment env) throws Exception {

    }

}
