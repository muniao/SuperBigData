package com.icocos.bigdata.dataset;

import org.apache.flink.api.java.ExecutionEnvironment;

public class DataSetTransformationJava {

    public static void main(String[] args) {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        mapFunction(env);
        filterFunction(env);
        mappartitionFunction(env);
        firstFunction(env);
        flatmapFunction(env);
        distinctFunction(env);
        joinFunction(env);
        outerjoinFunction(env);
        crossFunction(env);
    }

    /**
     * map
     */
    public static void mapFunction(ExecutionEnvironment env) {
        
    }

    /**
     * filter
     */
    public static void filterFunction(ExecutionEnvironment env) {

    }

    /**
     * mappartition
     */
    public static void mappartitionFunction(ExecutionEnvironment env) {

    }

    /**
     * first
     */
    public static void firstFunction(ExecutionEnvironment env) {

    }

    /**
     * flatmap
     */
    public static void flatmapFunction(ExecutionEnvironment env) {

    }

    /**
     * distinct
     */
    public static void distinctFunction(ExecutionEnvironment env) {

    }

    /**
     * join
     */
    public static void joinFunction(ExecutionEnvironment env) {

    }

    /**
     * outerjoin
     */
    public static void outerjoinFunction(ExecutionEnvironment env) {

    }

    /**
     * cross
     */
    public static void crossFunction(ExecutionEnvironment env) {

    }

}
