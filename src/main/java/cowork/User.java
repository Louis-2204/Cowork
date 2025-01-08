package cowork;

public class User {
    private int id_user;
    private String nom;
    private String prenom;
    private String email;
    private String password;
    private String entreprise;
    private String secteur_activte;
    private boolean is_admin;
    private int credits;

    public User (int id_user, String nom, String prenom, String email, String password, String entreprise, String secteur_activte, int credits) {
        this.id_user = id_user;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
        this.entreprise = entreprise;
        this.secteur_activte = secteur_activte;
        this.credits = credits;
    }


    public User (int id_user, String nom, String prenom, String email, String password, String entreprise, String secteur_activte) {
        this.id_user = id_user;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
        this.entreprise = entreprise;
        this.secteur_activte = secteur_activte;
        this.credits = 0;
    }

    public User (String nom, String prenom, String email, String password, String entreprise, String secteur_activte, int credits) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.password = password;
        this.entreprise = entreprise;
        this.secteur_activte = secteur_activte;
        this.credits = credits;
    }

    public User(String email, int id_user, boolean is_admin, int credits) {
        this.email = email;
        this.id_user = id_user;
        this.is_admin = is_admin;
        this.credits = credits;
    }




    public int getId_user() {return id_user;}
    public void setId_user(int id_user) {this.id_user = id_user;}

    public String getNom() {return nom;}
    public void setNom(String nom) {this.nom = nom;}

    public String getPrenom() {return prenom;}
    public void setPrenom(String prenom) {this.prenom = prenom;}

    public String getEmail() {return email;}
    public void setEmail(String email) {this.email = email;}

    public String getPassword() {return password;}
    public void setPassword(String password) {this.password = password;}

    public String getEntreprise() {return entreprise;}
    public void setEntreprise(String entreprise) {this.entreprise = entreprise;}

    public String getSecteur_activte() {return secteur_activte;}
    public void setSecteur_activte (String secteur_activte) {this.secteur_activte = secteur_activte;}

    public boolean getIs_admin() {return is_admin;}
    public void setIs_admin(boolean is_admin) {this.is_admin = is_admin;}

    public int getCredits() {return credits;}
    public void setCredits(int credits) {this.credits = credits;}
}
