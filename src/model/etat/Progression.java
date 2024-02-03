package model.etat;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import connection.BddObject;

public class Progression extends BddObject {

    Double etat;
    Double alerte;
    String comportement;
    String color;

    public Double getEtat() {
        return etat;
    }

    public void setEtat(Double etat) {
        if (etat < 0 || etat > 10)
            throw new IllegalArgumentException("Etat n'est pas définie");
        this.etat = etat;
    }

    public Double getAlerte() {
        return alerte;
    }

    public String getAlerteFormat() {
        return format(this.getAlerte(), "#");
    }

    public void setAlerte(Double alerte) {
        this.alerte = alerte;
    }

    public String getComportement() {
        return comportement;
    }

    public void setComportement(String comportement) {
        this.comportement = comportement;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public double getPourcentage() {
        return this.getEtat() * 10.0;
    }

    public String getPourcentageFormat() {
        return format(this.getPourcentage(), "#.##");
    }

    public static String format(double number, String pattern) {
        DecimalFormat df = new DecimalFormat(pattern);
        df.setRoundingMode(RoundingMode.CEILING);
        return df.format(number);
    }

    public Progression() throws Exception {
        super();
        this.setTable("comportement");
    }
    
}