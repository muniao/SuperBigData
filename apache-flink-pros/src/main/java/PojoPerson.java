public class PojoPerson {
    private String name;
    private int age;
    private String work;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getWork() {
        return work;
    }

    public void setWork(String work) {
        this.work = work;
    }

    @Override
    public String toString() {
        return "PojoPerson{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", work='" + work + '\'' +
                '}';
    }
}
