package model.immobilisation;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import connection.BddObject;
import model.adresse.Adresse;
import model.bien.Bien;
import model.categorie.Categorie;
import model.reception.Reception;

public class Immobilisation extends BddObject {

    String nom;
    Categorie categorie;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        if (nom.isEmpty())
            throw new IllegalArgumentException("Nom est vide");
        this.nom = nom;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

    public Immobilisation() throws Exception {
        super();
        this.setTable("immobilisation");
        this.setConnection("Oracle");
        this.setPrimaryKeyName("id_immobilisation");
    }

    public Reception recevoir(String date, String idAdresse, Connection connection) throws Exception {
        boolean connect = false;
        Reception reception = new Reception();
        reception.setDate(date);
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            Immobilisation immobilisation = (Immobilisation) new Immobilisation().setId(this.getId()).getById(connection);
            if (immobilisation == null) {
                throw new IllegalArgumentException(String.format("Immobilisation %s n'existe pas", this.getId()));
            }
            
            Adresse adresse = (Adresse) new Adresse().setId(idAdresse).getById(connection);
            if (adresse == null) {
                throw new IllegalArgumentException(String.format("Adresse %s n'existe pas", idAdresse));
            }

            reception.setImmobilisation(immobilisation);
            reception.setAdresse(adresse);

            String code = reception.generateCode(connection);
            reception.setCode(code);

        } finally {
            if (connect) {
                connection.close();
            }
        }
        return reception;
    }

    public Bien recevoir(String date, String idAdresse, String designation, String idMarque, Connection connection) throws Exception {
        boolean connect = false;
        Bien bien = null;
        Reception reception = null;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            reception = this.recevoir(date, idAdresse, connection);
            bien = reception.recuperer(designation, idMarque, connection);
            
            reception.insert(connection);
            bien.insert(connection);
            
            if (connect) {
                connection.commit();
            }
        } catch (Exception e) {
            if (connection != null) {
                connection.rollback();
            }
            throw e;
        } finally {
            if (connection != null && connect) {
                connection.close();
            }
        }
        return bien;
    }

    public Map<String, Object> getDropDown() throws Exception {
        Map<String, Object> map = new HashMap<>();
        try (Connection connection = this.getConnection()) {
            Immobilisation[] immobilisations = (Immobilisation[]) new Immobilisation().findAll(connection, null);
            Adresse[] adresses = (Adresse[]) new Adresse().findAll(connection, null); 
            map.put("immobilisations", immobilisations);
            map.put("adresses", adresses);
        }
        return map;
    }

    public Bien[] getEtatBien(Connection connection) throws Exception {
        Bien bien = new Bien();
        bien.setTable("v_liste_bien_etat");
        if (this.getId() != null) {
            bien.setImmobilisation(this);
        }
        return (Bien[]) bien.findAll(connection, "nom");
    }

}