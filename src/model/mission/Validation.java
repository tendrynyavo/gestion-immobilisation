package model.mission;

import java.sql.Connection;
import java.sql.Timestamp;
import connection.BddObject;
import connection.Column;
import connection.annotation.ColumnName;
import model.composant.Composant;
import model.inventaire.Inventaire;

public class Validation extends BddObject {

    Mission mission;
    Inventaire inventaire;
    @ColumnName("date_validation")
    Timestamp date;
    Composant[] composants;

    public Composant[] getComposants() {
        return composants;
    }

    public void setComposants(Composant[] composants) {
        this.composants = composants;
    }

    public Inventaire getInventaire() {
        return inventaire;
    }

    public void setInventaire(Inventaire inventaire) {
        this.inventaire = inventaire;
    }

    public Mission getMission() {
        return mission;
    }

    public void setMission(Mission mission) {
        this.mission = mission;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public Validation() throws Exception {
        super();
        this.setTable("valide_mission");
        this.setPrefix("VAL");
        this.setCountPK(7);
        this.setFunctionPK("seq_validation_mission.NEXTVAL");
        this.setConnection("Oracle");
        this.setPrimaryKeyName("id_validation");
    }

    @Override
    public void insert(Connection connection, Column... args) throws Exception {
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            // Insertion de la validation
            Composant[] composants = this.getComposants();
            this.setComposants(null);

            super.insert(connection, args);

            this.getMission().changerEtat(10, connection);

            // Ajouter les etats actuelles de la mission
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

    public void ajouterComposant(Composant composant, Connection connection) throws Exception {
        Composant c = new Composant();
        c.setId(composant.getId());
        c.setEtat(composant.getEtat());
        c.setTable("etat_inventaire");
        c.setSerial(false);
        c.insert(connection, new Column("id_validation", this.getId()));
    }

    public Validation valider(String idMission) throws Exception {
        Mission mission = new Mission();
        mission.setId(idMission);
        Connection connection = null;
        Validation validation = null;
        try {
            connection = this.getConnection();
            validation = mission.valider(connection);
            validation.insert(connection);
            connection.commit();
        } catch (Exception e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return validation;
    }

}