package dataset;

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
    public static void mapFunction(ExecutionEnvironment env) throw Exception {
        
    }

    /**
     * filter
     */
    public static void filterFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * mappartition
     */
    public static void mappartitionFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * first
     */
    public static void firstFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * flatmap
     */
    public static void flatmapFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * distinct
     */
    public static void distinctFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * join
     */
    public static void joinFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * outerjoin
     */
    public static void outerjoinFunction(ExecutionEnvironment env) throw Exception {

    }

    /**
     * cross
     */
    public static void crossFunction(ExecutionEnvironment env) throw Exception {

    }

}
