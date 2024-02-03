package model.inventaire;

import java.sql.Connection;
import java.sql.Date;
import connection.BddObject;
import connection.Column;
import connection.annotation.ColumnName;
import model.bien.Bien;
import model.composant.Composant;

public class Inventaire extends BddObject {

    Bien bien;
    @ColumnName("date_inventaire")
    Date date;
    Composant[] composants;

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setDate(String date) {
        if (date.isEmpty())
            throw new IllegalArgumentException("Date est vide");
        this.setDate(Date.valueOf(date));
    }

    public Composant[] getComposants() {
        return composants;
    }

    public void setComposants(Composant[] composants) {
        this.composants = composants;
    }

    public Inventaire() throws Exception {
        super();
        this.setTable("inventaire");
        this.setPrefix("INV");
        this.setCountPK(6);
        this.setConnection("Oracle");
        this.setFunctionPK("seq_inventaire.NEXTVAL");
        this.setPrimaryKeyName("id_inventaire");
    }

    public void ajouter(String[] values, String index) throws NumberFormatException, InventaireDoneException {
        this.ajouter(values, Integer.parseInt(index));
    }

    public void ajouter(String[] values, int index) throws InventaireDoneException {
        if (index >= this.getComposants().length)
            throw new InventaireDoneException();
        Composant[] filles = this.getComposants()[index].getComposants();
        for (int i = 0; i < values.length; i++) {
            filles[i].changerEtat(values[i]);
        }
    }

    public Composant get(String index) throws InventaireDoneException {
        int value = Integer.parseInt(index);
        if (value >= this.getComposants().length)
            throw new InventaireDoneException();
        return this.getComposants()[value];
    }

    @Override
    public void insert(Connection connection, Column... args) throws Exception {
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            this.getColumns().remove(2);
            super.insert(connection, args);

            for (Composant mere : this.getComposants()) {
                for (Composant fille : mere.getComposants()) {
                    this.ajouterComposant(fille, connection);
                }
            }

            connection.commit();
        } catch (Exception e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connect && connection != null) {
                connection.close();
            }
        }
    }

    public void ajouterComposant(Composant composant, Connection connection) throws Exception {
        composant.setTable("etat_composant");
        composant.setSerial(false);
        composant.setCapacite(null);
        composant.setNom(null);
        composant.setUnite(null);
        composant.setBien(null);
        composant.insert(connection, new Column("id_inventaire", this.getId()));
    }
    
}