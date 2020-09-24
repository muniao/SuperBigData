package com.icocos.bigdata.datastream;

import org.apache.flink.api.java.ExecutionEnvironment;

public class DataStreamTransformationJava {

    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        mapFunction(env);
        filterFunction(env);
        unionFunction(env);
        splitFunction(env);
    }

    public static void mapFunction(ExecutionEnvironment env) throws Exception {

    }

    public static void filterFunction(ExecutionEnvironment env) throws Exception {

    }

    public static void unionFunction(ExecutionEnvironment env) throws Exception {

    }

    public static void splitFunction(ExecutionEnvironment env) throws Exception {

    }

}
