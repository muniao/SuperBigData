package com.icocos.bigdata.datastream;

import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.streaming.api.collector.selector.OutputSelector;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SplitStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import java.util.ArrayList;
import java.util.List;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/datastream_api.html
public class DataStreamTransformationJava {

    public static void main(String[] args) throws Exception {

        // 1. 获取上下文
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        mapFunction(env);
        filterFunction(env);
        unionFunction(env);
        splitFunction(env);
        selectFunction(env);
        env.execute();
    }

    public static void mapFunction(StreamExecutionEnvironment env) throws Exception {
        DataStreamSource<Integer> data1 = null; // env.socketTextStream("host", 9999);
        data1.map(new MapFunction<Integer, Integer>() {
            @Override
            public Integer map(Integer value) throws Exception {
                return 2 * value;
            }
        });
    }

    public static void filterFunction(StreamExecutionEnvironment env) throws Exception {
        DataStreamSource<Integer> data1 = null; // env.socketTextStream("host", 9999);
        data1.filter(new FilterFunction<Integer>() {
            @Override
            public boolean filter(Integer value) throws Exception {
                return value != 0;
            }
        });
    }

    public static void unionFunction(StreamExecutionEnvironment env) throws Exception {
        DataStream<String> data1 = env.socketTextStream("host", 9999);
        DataStream<String> data2 = env.socketTextStream("host", 9999);
        DataStream<String> data3 = env.socketTextStream("host", 9999);
        data1.union(data2, data3);
    }

    public static void splitFunction(StreamExecutionEnvironment env) throws Exception {
        DataStreamSource<Integer> data1 = null; // env.socketTextStream("host", 9999);
        SplitStream<Integer> split = data1.split(new OutputSelector<Integer>() {
            @Override
            public Iterable<String> select(Integer value) {
                List<String> output = new ArrayList<String>();
                if (value % 2 == 0) {
                    output.add("even");
                }
                else {
                    output.add("odd");
                }
                return output;
            }
        });
    }

    public static void selectFunction(StreamExecutionEnvironment env) throws Exception {
        DataStreamSource<Integer> data1 = null; // env.socketTextStream("host", 9999);
        SplitStream<Integer> split = null;
        DataStream<Integer> even = split.select("even");
        DataStream<Integer> odd = split.select("odd");
        DataStream<Integer> all = split.select("even","odd");
    }
}
