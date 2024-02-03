package model.composant;

import model.bien.Bien;
import model.etat.Progression;

public class Composant extends Progression {

    String nom;
    Double nombre;
    Double capacite;
    String unite;
    Bien bien;
    Composant[] composants;

    public Double getCapacite() {
        return capacite;
    }

    public void setCapacite(Double capacite) {
        this.capacite = capacite;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public Double getNombre() {
        return nombre;
    }

    public void setNombre(Double nombre) {
        this.nombre = nombre;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Composant[] getComposants() {
        return composants;
    }

    public void setComposants(Composant[] composants) {
        this.composants = composants;
    }

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public double getEtatReel() {
        return (this.getEtat() / 10.0) * this.getCapacite();
    }

    public boolean isConsommable() {
        return (this.getUnite() != null);
    }

    public String getReste() {
        if (!this.isConsommable())
            return "-";
        return format(this.getEtatReel(), "#.##") + " " + this.getUnite();
    }

    public boolean isFille() {
        return this.getNombre() <= 1.0;
    }

    public void changerEtat(String etat) {
        if (etat.isEmpty()) {
            throw new IllegalArgumentException("Etat est vide");
        }
        this.changerEtat(Double.parseDouble(etat));
    }

    public void changerEtat(double etat) {
        double result = etat;
        if (this.isConsommable()) {
            result = (etat * 10) / this.getCapacite();
        }
        this.setEtat(result);
    }

    public String getLabel() {
        String unite = "";
        String max = "";
        if (this.isConsommable()) {
            unite = "(" + this.getUnite() + ")";
            max = "Max : " + this.getCapacite();
        }
        return this.getNom() + " " + unite + " " + max;
    }

    public Composant() throws Exception {
        super();
        this.setTable("COMPOSANT");
        this.setPrimaryKeyName("id_composant");
        this.setConnection("Oracle");
    }

}