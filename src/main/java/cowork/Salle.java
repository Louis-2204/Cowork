package cowork;

public class Salle {
    private int id_salle;
    private String label;
    private String type_espace;
    private int capacite;
    private String image_url;

    public Salle(int id_salle, String label, String type_espace, int capacite, String image_url) {
        this.id_salle = id_salle;
        this.label = label;
        this.type_espace = type_espace;
        this.capacite = capacite;
        this.image_url = image_url;
    }

    public int getId_salle() {
        return id_salle;
    }

    public void setId_salle(int id_salle) {
        this.id_salle = id_salle;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getType_espace() {
        return type_espace;
    }

    public void setType_espace(String type_espace) {
        this.type_espace = type_espace;
    }

    public int getCapacite() {
        return capacite;
    }

    public void setCapacite(int capacite) {
        this.capacite = capacite;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }
}
