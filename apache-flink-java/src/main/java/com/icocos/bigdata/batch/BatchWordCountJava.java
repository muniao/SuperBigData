package com.icocos.bigdata.batch;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.util.Collector;

public class BatchWordCountJava {
    public static void main(String[] args) throws Exception {

        // 1. 获取上下文
        final ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();

        // 2. 读入数据
        String input = "/Users/iCocos/Desktop/BigData/SuperBigData/ApacheFlink/src/main/resources/input";
        DataSource<String> text = env.readTextFile(input);
        //text.print();

        // 3. 转换操作
        text.flatMap(new FlatMapFunction<String, Tuple2<String,Integer>>() {
            @Override
            public void flatMap(String value, Collector<Tuple2<String, Integer>> collector) throws Exception {
                String[] tokens = value.toLowerCase().split("\t");
                for (String token: tokens) {
                    if (token.length() >0) {
                        collector.collect(new Tuple2<String, Integer>(token,1));
                    }
                }
            }
        }).groupBy(0).sum(1).print();

        // 打印
        System.out.println("---------");

    }
}
