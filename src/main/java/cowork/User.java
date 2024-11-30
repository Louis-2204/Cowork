package cowork;

public class User {
    private String id_user;
    private String nom;
    private String prenom;
    private String email;
    private String password;
    private String entreprise;
    private String secteur_activite;

    public User(String id_user, String nom, String prenom, String email, String password, String entreprise, String secteur_activite) {
        this.id_user = id_user;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
        this.entreprise = entreprise;
        this.secteur_activite = secteur_activite;
    }

    public String getId_user() {
        return id_user;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getEntreprise() {
        return entreprise;
    }

    public String getSecteur_activite() {
        return secteur_activite;
    }
}
