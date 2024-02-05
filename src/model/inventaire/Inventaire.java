package model.inventaire;

import java.sql.Connection;
import java.sql.Timestamp;
import java.text.ParseException;
import connection.BddObject;
import connection.Column;
import connection.annotation.ColumnName;
import model.bien.Bien;
import model.composant.Composant;
import model.mission.Mission;

public class Inventaire extends BddObject {

    Bien bien;
    @ColumnName("date_inventaire")
    Timestamp date;
    Composant[] composants;

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        if (date.after(new Timestamp(System.currentTimeMillis())))
            throw new IllegalArgumentException("Inventaire avec date invalide");
        this.date = date;
    }

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public void setDate(String date) throws IllegalArgumentException, ParseException {
        this.setDate(Mission.toDate(date));
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

    public void insertInventaire(Connection connection, Column... args) throws Exception {
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
        Composant c = new Composant();
        c.setTable("etat_composant");
        c.setSerial(false);
        c.setId(composant.getId());
        c.setEtat(composant.getEtat());
        c.insert(connection, new Column("id_inventaire", this.getId()));
    }

    public void confirmer(Connection connection) throws Exception {
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            Composant[] composants = this.getComposants();
            this.setComposants(null);
            this.insert(connection);

            for (Composant composant : composants) {
                this.ajouterComposant(composant, connection);
            }

            if (connect) {
                connection.commit();
            }
        } catch (Exception e) {
            if (connection != null && connect) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null && connect) {
                connection.close();
            }
        }
    }
    
}