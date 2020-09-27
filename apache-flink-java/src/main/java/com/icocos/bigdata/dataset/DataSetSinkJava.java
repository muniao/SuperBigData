package com.icocos.bigdata.dataset;

import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.core.fs.FileSystem;

import java.util.ArrayList;
import java.util.List;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
public class DataSetSinkJava {

    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        writeAsText(env);
    }

    public static void writeAsText(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        String path = "/Users/iCocos/Desktop/BigData/SuperBigData/.output/sink-java/";
        dataSource.writeAsText(path, FileSystem.WriteMode.OVERWRITE).setParallelism(2);
        env.execute("执行Sink");
    }

}
