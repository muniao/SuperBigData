package com.icocos.bigdata.dataset;

import org.apache.flink.api.common.functions.*;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.DataSource;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.tuple.Tuple3;
import org.apache.flink.util.Collector;
import scala.collection.mutable.ListBuffer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/batch/index.html
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
    public static void mappartitionFunction(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        dataSource.mapPartition(new MapPartitionFunction<Integer, Integer>() {
            @Override
            public void mapPartition(Iterable<Integer> values, Collector<Integer> out) throws Exception {
                int val = 0;
                for (Integer value: values) {
                    val++;
                }
                out.collect(val);
            }
        }).print();
    }

    /**
     * first
     */
    public static void firstFunction(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        DataSource<Integer> dataSource = env.fromCollection(list);
        dataSource.first(3).print();
    }

    /**
     * flatmap
     */
    public static void flatmapFunction(ExecutionEnvironment env) throws Exception {
        List<String> info = new ArrayList<String>();
        info.add("na,me");
        info.add("nam,e1");
        info.add("n,ame3");
        DataSource<String> dataSource = env.fromCollection(info);
        dataSource.flatMap(new FlatMapFunction<String, String>() {
            @Override
            public void flatMap(String value, Collector<String> out) throws Exception {
                String[] splits = value.split(",");
                for (String split: splits) {
                    out.collect(split);
                }
            }
        }).map(new MapFunction<String, Tuple2<String,Integer>>() {
            @Override
            public Tuple2<String, Integer> map(String value) throws Exception {
                 return new Tuple2<String, Integer>(value,1);
            }
        }).groupBy(0).sum(1).print();

    }

    /**
     * distinct
     */
    public static void distinctFunction(ExecutionEnvironment env) throws Exception {
        List<String> info = new ArrayList<String>();
        info.add("na,me");
        info.add("nam,e1");
        info.add("n,ame3");
        DataSource<String> dataSource = env.fromCollection(info);
        dataSource.flatMap(new FlatMapFunction<String, String>() {
            @Override
            public void flatMap(String value, Collector<String> out) throws Exception {
                String[] splits = value.split(",");
                for (String split: splits) {
                    out.collect(split);
                }
            }
        }).distinct().print();
    }

    /**
     * join
     */
    public static void joinFunction(ExecutionEnvironment env) throws Exception {
        List<Tuple2<Integer,String>> info1 = new ArrayList<Tuple2<Integer,String>>();
        info1.add(new Tuple2<>(1,"nam,e1"));
        info1.add(new Tuple2<>(2,"nam,e2"));
        info1.add(new Tuple2<>(3,"nam,e3"));

        List<Tuple2<Integer,String>> info2 = new ArrayList<Tuple2<Integer,String>>();
        info2.add(new Tuple2<>(1,"nam,e1"));
        info2.add(new Tuple2<>(2,"nam,e2"));
        info2.add(new Tuple2<>(4,"nam,e4"));

        DataSource<Tuple2<Integer,String>> dataSource1 = env.fromCollection(info1);
        DataSource<Tuple2<Integer,String>> dataSource2 = env.fromCollection(info2);

        dataSource1.join(dataSource2).where(0).equalTo(0).with(new JoinFunction<Tuple2<Integer, String>, Tuple2<Integer, String>, Tuple3<Integer,String,String>>() {
            @Override
            public Tuple3<Integer, String, String> join(Tuple2<Integer, String> first, Tuple2<Integer, String> second) throws Exception {
                return new Tuple3<Integer,String,String>(first.f0,first.f1,second.f1);
            }
        }).print();
    }

    /**
     * outerjoin
     */
    public static void outerjoinFunction(ExecutionEnvironment env) throws Exception {
        List<Tuple2<Integer,String>> info1 = new ArrayList<Tuple2<Integer,String>>();
        info1.add(new Tuple2<>(1,"nam,e1"));
        info1.add(new Tuple2<>(2,"nam,e2"));
        info1.add(new Tuple2<>(3,"nam,e3"));

        List<Tuple2<Integer,String>> info2 = new ArrayList<Tuple2<Integer,String>>();
        info2.add(new Tuple2<>(1,"nam,e1"));
        info2.add(new Tuple2<>(2,"nam,e2"));
        info2.add(new Tuple2<>(4,"nam,e4"));

        DataSource<Tuple2<Integer,String>> dataSource1 = env.fromCollection(info1);
        DataSource<Tuple2<Integer,String>> dataSource2 = env.fromCollection(info2);

        dataSource1.leftOuterJoin(dataSource2).where(0).equalTo(0).with(new JoinFunction<Tuple2<Integer, String>, Tuple2<Integer, String>, Tuple3<Integer,String,String>>() {
            @Override
            public Tuple3<Integer, String, String> join(Tuple2<Integer, String> first, Tuple2<Integer, String> second) throws Exception {
                if (second == null) {
                    return new Tuple3<Integer,String,String>(first.f0,first.f1,null);
                } else {
                    return new Tuple3<Integer,String,String>(first.f0,first.f1,second.f1);
                }
            }
        }).print();
    }

    /**
     * cross
     */
    public static void crossFunction(ExecutionEnvironment env) throws Exception {
        List<Tuple2<Integer,String>> info1 = new ArrayList<Tuple2<Integer,String>>();
        info1.add(new Tuple2<>(1,"nam,e1"));
        info1.add(new Tuple2<>(2,"nam,e2"));
        info1.add(new Tuple2<>(3,"nam,e3"));

        List<Tuple2<Integer,String>> info2 = new ArrayList<Tuple2<Integer,String>>();
        info2.add(new Tuple2<>(1,"nam,e1"));
        info2.add(new Tuple2<>(2,"nam,e2"));
        info2.add(new Tuple2<>(4,"nam,e4"));

        DataSource<Tuple2<Integer,String>> dataSource1 = env.fromCollection(info1);
        DataSource<Tuple2<Integer,String>> dataSource2 = env.fromCollection(info2);

        dataSource1.cross(dataSource2).print();
    }

}
