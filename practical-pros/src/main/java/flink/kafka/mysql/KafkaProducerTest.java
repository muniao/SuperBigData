package flink.kafka.mysql;

import com.google.gson.Gson;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.KafkaProducer;

import java.util.Properties;
import java.util.Random;

public class KafkaProducerTest {
    public static void main(String[] args) {
        Producer();
    }

    public static void Producer() {
        String broker = "localhost:9092";
        String topic = "demo";
        Properties props = new Properties();
        props.put("bootstrap.servers", broker);
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        KafkaProducer producer = new KafkaProducer<String, String>(props);

        String[] depLists = new String[5];
        depLists[0] = "行政部";
        depLists[1] = "账务部";
        depLists[2] = "市场部";
        depLists[3] = "技术部";
        depLists[4] = "销售部";

        Random rand = new Random(300);
        Gson gson = new Gson();
        for (int i = 1; i <= 1000; i++) {
            Employee employee = new Employee(i, "user" + i, "password" + i, rand.nextInt(40) + 20, (rand.nextInt(300) + 1) * 100, depLists[rand.nextInt(5)]);
            String temp = gson.toJson(employee).toString();
            ProducerRecord record = new ProducerRecord<String, String>(topic, null, "user" + i, temp);
            producer.send(record);
            System.out.println("发送数据: " + temp);
            try {
                Thread.sleep(1 * 1000); //发送一条数据 sleep
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        producer.flush();
    }
}