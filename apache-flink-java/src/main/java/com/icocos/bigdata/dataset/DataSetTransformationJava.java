package com.icocos.bigdata.dataset;

import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;

import java.util.ArrayList;
import java.util.List;

public class DataSetTransformationJava {

    public static void main(String[] args) throws Exception {
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
    public static void mapFunction(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        dataSource.map(new MapFunction<Integer, Integer>() {
            @Override
            public Integer map(Integer value) throws Exception {
                return value + 1;
            }
        }).print();
    }

    /**
     * filter
     */
    public static void filterFunction(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        dataSource.map(new MapFunction<Integer, Integer>() {
            @Override
            public Integer map(Integer value) throws Exception {
                return value + 1;
            }
        }).filter(new FilterFunction<Integer>() {
            @Override
            public boolean filter(Integer value) throws Exception {
                return value > 5;
            }
        }).print();

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
