package model.caracteristique;

import connection.BddObject;
import model.bien.Bien;
import model.immobilisation.Immobilisation;

public class Caracteristique extends BddObject {

    String nom;
    Bien bien;
    String valeur;
    Immobilisation immobilisation;

    public Immobilisation getImmobilisation() {
        return immobilisation;
    }

    public void setImmobilisation(Immobilisation immobilisation) {
        this.immobilisation = immobilisation;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public String getValeur() {
        return valeur;
    }

    public void setValeur(String valeur) {
        this.valeur = valeur;
    }

    public Caracteristique() throws Exception {
        super();
        this.setTable("caracteristique");
        this.setPrimaryKeyName("id_caracteristique");
        this.setConnection("Oracle");
    }
    
}
