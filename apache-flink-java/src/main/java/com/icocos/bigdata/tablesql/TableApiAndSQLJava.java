package com.icocos.bigdata.tablesql;

import org.apache.flink.api.java.DataSet;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.EnvironmentSettings;
import org.apache.flink.table.api.Table;
import org.apache.flink.table.api.java.StreamTableEnvironment;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.table.api.java.BatchTableEnvironment;
import org.apache.flink.table.api.TableEnvironment;
import org.apache.flink.types.Row;

//https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/table/common.html
public class TableApiAndSQLJava {

    //// **********************
    //// FLINK STREAMING QUERY
    //// **********************
    //import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
    //import org.apache.flink.table.api.EnvironmentSettings;
    //import org.apache.flink.table.api.java.StreamTableEnvironment;
    //
    //EnvironmentSettings fsSettings = EnvironmentSettings.newInstance().useOldPlanner().inStreamingMode().build();
    //StreamExecutionEnvironment fsEnv = StreamExecutionEnvironment.getExecutionEnvironment();
    //StreamTableEnvironment fsTableEnv = StreamTableEnvironment.create(fsEnv, fsSettings);
    //// or TableEnvironment fsTableEnv = TableEnvironment.create(fsSettings);
    //
    //// ******************
    //// FLINK BATCH QUERY
    //// ******************
    //import org.apache.flink.api.java.ExecutionEnvironment;
    //import org.apache.flink.table.api.java.BatchTableEnvironment;
    //
    //ExecutionEnvironment fbEnv = ExecutionEnvironment.getExecutionEnvironment();
    //BatchTableEnvironment fbTableEnv = BatchTableEnvironment.create(fbEnv);
    //
    //// **********************
    //// BLINK STREAMING QUERY
    //// **********************
    //import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
    //import org.apache.flink.table.api.EnvironmentSettings;
    //import org.apache.flink.table.api.java.StreamTableEnvironment;
    //
    //StreamExecutionEnvironment bsEnv = StreamExecutionEnvironment.getExecutionEnvironment();
    //EnvironmentSettings bsSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inStreamingMode().build();
    //StreamTableEnvironment bsTableEnv = StreamTableEnvironment.create(bsEnv, bsSettings);
    //// or TableEnvironment bsTableEnv = TableEnvironment.create(bsSettings);
    //
    //// ******************
    //// BLINK BATCH QUERY
    //// ******************
    //import org.apache.flink.table.api.EnvironmentSettings;
    //import org.apache.flink.table.api.TableEnvironment;
    //
    //EnvironmentSettings bbSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inBatchMode().build();
    //TableEnvironment bbTableEnv = TableEnvironment.create(bbSettings);

    public static void main(String[] args) throws Exception {
        ExecutionEnvironment batchEnv1 = ExecutionEnvironment.getExecutionEnvironment();
        batchTableFunction1(batchEnv1);

        StreamExecutionEnvironment streamEnv1 = StreamExecutionEnvironment.getExecutionEnvironment();
        streamTableFunction1(streamEnv1);

        ExecutionEnvironment batchEnv2 = ExecutionEnvironment.getExecutionEnvironment();
        batchTableFunction2(batchEnv2);

        StreamExecutionEnvironment streamEnv2 = StreamExecutionEnvironment.getExecutionEnvironment();
        streamTableFunction2(streamEnv2);
    }

    public static void batchTableFunction1(ExecutionEnvironment env) throws Exception {
        ExecutionEnvironment fbEnv = ExecutionEnvironment.getExecutionEnvironment();
        BatchTableEnvironment fbTableEnv = BatchTableEnvironment.create(fbEnv);

        String filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.csv";
        DataSet<UserInfoData> csv = env.readCsvFile(filePath).ignoreFirstLine().pojoType(UserInfoData.class,"user_id", "create_time", "name", "mobile");
        //csv.print();

        Table userInfo = fbTableEnv.fromDataSet(csv);
        fbTableEnv.registerTable("user_info",userInfo);
        Table results = fbTableEnv.sqlQuery("select create_time,count(*) from user_info group by create_time");
        fbTableEnv.toDataSet(results,Row.class).print();
    }

    public static void streamTableFunction1(StreamExecutionEnvironment env) {
        EnvironmentSettings fsSettings = EnvironmentSettings.newInstance().useOldPlanner().inStreamingMode().build();
        StreamExecutionEnvironment fsEnv = StreamExecutionEnvironment.getExecutionEnvironment();
        StreamTableEnvironment fsTableEnv = StreamTableEnvironment.create(fsEnv, fsSettings);
        // or TableEnvironment fsTableEnv = TableEnvironment.create(fsSettings);
    }


    public static void batchTableFunction2(ExecutionEnvironment env) {
        EnvironmentSettings bbSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inBatchMode().build();
        TableEnvironment bbTableEnv = TableEnvironment.create(bbSettings);
    }

    public static void streamTableFunction2(StreamExecutionEnvironment env) {
        StreamExecutionEnvironment bsEnv = StreamExecutionEnvironment.getExecutionEnvironment();
        EnvironmentSettings bsSettings = EnvironmentSettings.newInstance().useBlinkPlanner().inStreamingMode().build();
        StreamTableEnvironment bsTableEnv = StreamTableEnvironment.create(bsEnv, bsSettings);
        // or TableEnvironment bsTableEnv = TableEnvironment.create(bsSettings);
    }

    public static class UserInfoData {
        public String user_id;
        public String create_time;
        public String name;
        public String mobile;
    }

}
