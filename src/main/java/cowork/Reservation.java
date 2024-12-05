package cowork;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Reservation {

    private String id_user;
    private String id_salle;
    private Timestamp timestamp_deb;
    private Timestamp timestamp_fin;
    private String code;
    private ArrayList<Equipement> equipements;
    private Salle salle;

    public Reservation(String id_user, String id_salle, Timestamp timestamp_deb, Timestamp timestamp_fin, String code, ArrayList<Equipement> equipements, Salle salle) {
        this.id_user = id_user;
        this.id_salle = id_salle;
        this.timestamp_deb = timestamp_deb;
        this.timestamp_fin = timestamp_fin;
        this.code = code;
        this.equipements = equipements;
        this.salle = salle;
    }

    public String getIdUser() {
        return id_user;
    }

    public String getIdSalle() {
        return id_salle;
    }

    public Timestamp getTimestampDeb() {
        return timestamp_deb;
    }

    public Timestamp getTimestampFin() {
        return timestamp_fin;
    }

    public String getCode() {
        return code;
    }

    public ArrayList<Equipement> getEquipements() {
        return equipements;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setIdUser(String id_user) {
        this.id_user = id_user;
    }

    public void setIdSalle(String id_salle) {
        this.id_salle = id_salle;
    }

    public void setTimestampDeb(Timestamp timestamp_deb) {
        this.timestamp_deb = timestamp_deb;
    }

    public void setTimestampFin(Timestamp timestamp_fin) {
        this.timestamp_fin = timestamp_fin;
    }
}
