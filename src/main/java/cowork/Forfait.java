package cowork;

public class Forfait {
    private int id_forfait;
    private String label;
    private String description;
    private String type_espace;
    private String image_url;
    private int prix;
    private String heure_deb;
    private String heure_fin;

    public Forfait(int id_forfait, String label, String description, String type_espace, String image_url, int prix, String heure_deb, String heure_fin) {
        this.id_forfait = id_forfait;
        this.label = label;
        this.description = description;
        this.type_espace = type_espace;
        this.image_url = image_url;
        this.prix = prix;
        this.heure_deb = heure_deb;
        this.heure_fin = heure_fin;
    }

    public int getId_forfait() {
        return id_forfait;
    }

    public void setId_forfait(int id_forfait) {
        this.id_forfait = id_forfait;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType_espace() {
        return type_espace;
    }

    public void setType_espace(String type_espace) {
        this.type_espace = type_espace;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public int getPrix() {
        return prix;
    }

    public void setPrix(int prix) {
        this.prix = prix;
    }

    public String getHeure_deb() {
        return heure_deb;
    }

    public void setHeure_deb(String heure_deb) {
        this.heure_deb = heure_deb;
    }

    public String getHeure_fin() {
        return heure_fin;
    }

    public void setHeure_fin(String heure_fin) {
        this.heure_fin = heure_fin;
    }
}
