package com.icocos.bigdata.dataset;

import org.apache.flink.api.common.JobExecutionResult;
import org.apache.flink.api.common.accumulators.LongCounter;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.core.fs.FileSystem;

import java.util.ArrayList;
import java.util.List;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
public class DataSetCounterJava {

    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        counterFunction(env);
    }

    public static void counterFunction(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        DataSet<Integer> info = dataSource.map(new RichMapFunction<Integer, Integer>() {
            // 定义计数器
            LongCounter counter = new LongCounter();
            @Override
            public void open(Configuration parameters) throws Exception {
                super.open(parameters);
                getRuntimeContext().addAccumulator("ele-counts-java",counter);
            }

            @Override
            public Integer map(Integer value) throws Exception {
                counter.add(1);
                return value;
            }
        });
        String path = "/Users/iCocos/Desktop/BigData/SuperBigData/.output/sink-scala/";
        info.writeAsText(path, FileSystem.WriteMode.OVERWRITE).setParallelism(2);
        JobExecutionResult job = env.execute("执行Counter");
        // 获取计数器
        long num = job.getAccumulatorResult("ele-counts-java");
        System.out.println(num);
    }
}
