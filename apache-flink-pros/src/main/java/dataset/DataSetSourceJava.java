package dataset;

import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.configuration.Configuration;

import java.util.ArrayList;
import java.util.List;

public class DataSetSourceJava {
    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        //fromCollection(env)
        //fromTextFile(env)
        //fromCSVFile(env)
        //fromResvFile(env)
        //fromZipFile(env)
    }

    /**
     * 从集合创建
     */
    public static void fromCollection(ExecutionEnvironment env) throws Exception {
        List<Integer> list = new ArrayList<Integer>();
        for (int i=1; i <=100; i++) {
            list.add(i);
        }
        env.fromCollection(list).print();
    }

    /**
     * 从文件创建：可指定文件夹直接读取
     */
    public static void fromTextFile(ExecutionEnvironment env) throws Exception {
        String filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.txt";
        env.readTextFile(filePath).print();
    }

    /**
     * 从CSV文件创建
     */
    public static void fromCSVFile(ExecutionEnvironment env) throws Exception {
        String filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.csv";
        env.readCsvFile(filePath);
    }

    /**
     * 从递归文件创建
     */
    public static void fromResvFile(ExecutionEnvironment env) throws Exception {
        String filePath = "/Users/iCocos/Desktop/BigData/SuperBigData";
        Configuration parameters = new Configuration();
        parameters.setBoolean("recuresive.file.enumeration",true);
        env.readTextFile(filePath).withParameters(parameters).print();
    }

    /**
     * 从压缩文件创建
     */
    public static void fromZipFile(ExecutionEnvironment env) throws Exception {
        String filePath = "/Users/iCocos/Desktop/BigData/SuperBigData/input.zip";
        env.readTextFile(filePath).print();
    }

}
