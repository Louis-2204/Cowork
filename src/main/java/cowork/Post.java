package cowork;

import java.util.ArrayList;

public class Post {
    private int id_post;
    private String content;
    private String created_at;
    private String id_parent;
    private String id_user;
    private User user;
    private ArrayList<Post> answers;

    public Post(int id_post, String content, String created_at, String id_parent, String id_user) {
        this.id_post = id_post;
        this.content = content;
        this.created_at = created_at;
        this.id_parent = id_parent;
        this.id_user = id_user;
    }

    public Post(int id_post, String content, String created_at, String id_parent, String id_user, User user) {
        this.id_post = id_post;
        this.content = content;
        this.created_at = created_at;
        this.id_parent = id_parent;
        this.id_user = id_user;
        this.user = user;
    }

    public Post(int id_post, String content, String created_at, String id_parent, String id_user, User user, ArrayList<Post> answers) {
        this.id_post = id_post;
        this.content = content;
        this.created_at = created_at;
        this.id_parent = id_parent;
        this.id_user = id_user;
        this.user = user;
        this.answers = answers;
    }

    public int getId_post() {
        return id_post;
    }

    public String getContent() {
        return content;
    }

    public String getCreated_at() {
        return created_at;
    }

    public String getId_parent() {
        return id_parent;
    }

    public String getId_user() {
        return id_user;
    }

    public User getUser() {
        return user;
    }

    public ArrayList<Post> getAnswers() {
        return answers;
    }

    public void setAnswers(ArrayList<Post> answers) {
        this.answers = answers;
    }
}