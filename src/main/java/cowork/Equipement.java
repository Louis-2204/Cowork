package cowork;

public class Equipement {
    private int id_equipement;
    private String label;

    public Equipement(String label) {
        this.label = label;
    }

    public Equipement(int id_equipement, String label) {
        this.id_equipement = id_equipement;
        this.label = label;
    }

    public int getId_equipement() {
        return id_equipement;
    }

    public void setId_equipement(int id_equipement) {
        this.id_equipement = id_equipement;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}