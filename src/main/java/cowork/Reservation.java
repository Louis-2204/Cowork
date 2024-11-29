package cowork;

import java.util.List;

public class Reservation {

    private String id;
    private String type;
    private String name;
    private String date;
    private String code;
    private List<String> tags;

    public Reservation(String id, String type, String name, String date, String code, List<String> tags) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.date = date;
        this.code = code;
        this.tags = tags;
    }

    public String getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    public String getDate() {
        return date;
    }

    public String getCode() {
        return code;
    }

    public List<String> getTags() {
        return tags;
    }

}
