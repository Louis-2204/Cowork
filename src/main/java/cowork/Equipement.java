package cowork;

public class Equipement {
    private String id_equipement;
    private String label;

    public Equipement(String label) {
        this.label = label;
    }

    public Equipement(String id_equipement, String label) {
        this.id_equipement = id_equipement;
        this.label = label;
    }

    public String getIdEquipement() {
        return id_equipement;
    }

    public String getLabel() {
        return label;
    }

    public void setIdEquipement(String id_equipement) {
        this.id_equipement = id_equipement;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}
