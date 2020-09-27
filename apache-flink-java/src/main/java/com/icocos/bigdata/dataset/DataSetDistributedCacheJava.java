package com.icocos.bigdata.dataset;

import org.apache.commons.io.FileUtils;
import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.api.java.DataSet;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.configuration.Configuration;

import java.io.File;
import java.util.List;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
public class DataSetDistributedCacheJava {

    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        counterFunction(env);
    }

    public static void counterFunction(ExecutionEnvironment env) throws Exception {
        String path = "/Users/iCocos/Desktop/BigData/SuperBigData/input.txt";
        env.registerCachedFile(path,"input-text-java");

        DataSet<String> data = env.fromElements("111","222","333","444","555");
        data.map(new RichMapFunction<String, String>() {
            @Override
            public void open(Configuration parameters) throws Exception {
                super.open(parameters);
                File dFile = getRuntimeContext().getDistributedCache().getFile("input-text-java");
                List<String> list =  FileUtils.readLines(dFile);
                for (String ele: list) {
                    System.out.println(ele);
                }
            }
            @Override
            public String map(String value) throws Exception {
                return value;
            }
        }).print();
    }
}
