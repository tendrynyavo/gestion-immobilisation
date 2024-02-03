package model.bien;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.caracteristique.Caracteristique;
import model.composant.Composant;
import model.inventaire.Inventaire;
import model.marque.Marque;
import model.reception.Reception;

public class Bien extends Reception {

    String nom;
    Marque marque;
    Caracteristique[] caracteristiques;

    public Caracteristique[] getCaracteristiques() {
        return caracteristiques;
    }

    public void setCaracteristiques(Caracteristique[] caracteristiques) {
        this.caracteristiques = caracteristiques;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        if (nom.isEmpty())
            throw new IllegalArgumentException("Nom est vide");
        this.nom = nom;
    }

    public Marque getMarque() {
        return marque;
    }

    public void setMarque(Marque marque) {
        this.marque = marque;
    }

    public Bien() throws Exception {
        super();
        this.setTable("bien");
        this.setConnection("Oracle");
        this.setPrimaryKeyName("code");
        this.setSerial(false);
    }

    public Caracteristique[] getCaracteristiques(Connection connection) throws Exception {
        Caracteristique caracteristique = new Caracteristique();
        caracteristique.setImmobilisation(this.getMarque().getImmobilisation());
        Caracteristique[] caracteristiques = (Caracteristique[]) caracteristique.findAll(connection, null);
        this.setCaracteristiques(caracteristiques);
        return caracteristiques;
    }

    public Bien detail(String id, boolean dashboard, Connection connection) throws Exception {
        Bien bien = new Bien();
        bien.setCode(id);
        Caracteristique[] caracteristiques = null;
        boolean connect = false;
        bien.setTable("v_bien");
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            if (dashboard) {
                Caracteristique caracteristique = new Caracteristique();
                caracteristique.setTable("v_caracteristique_bien");
                caracteristique.setBien(bien);
                caracteristiques = (Caracteristique[]) caracteristique.findAll(connection, null);
                bien.setTable("V_LISTE_BIEN_ETAT");
                bien = (Bien) bien.getById(connection);
            } else {
                bien = (Bien) bien.getById(connection);
                caracteristiques = bien.getCaracteristiques(connection);
            }

            bien.setCaracteristiques(caracteristiques);
        } finally {
            if (connect) {
                connection.close();
            }
        }
        return bien;
    }

    public Caracteristique[] caracteriser(String[] values, Connection connection) throws Exception {
        Caracteristique[] caracteristiques = this.getCaracteristiques(connection);
        if (values.length != caracteristiques.length)  
            throw new IllegalArgumentException("Values insufficant");

        for (int i = 0; i < caracteristiques.length; i++) {
            caracteristiques[i].setBien(this);
            caracteristiques[i].setValeur(values[i]);
        }
        return caracteristiques;
    }

    public void ajouter(Caracteristique caracteristique, Connection connection) throws Exception {
        caracteristique.setTable("detail_bien");
        caracteristique.setSerial(false);
        caracteristique.setBien(this);
        caracteristique.setNom(null);
        caracteristique.setImmobilisation(null);
        caracteristique.insert(connection);
    }

    public void ajouter(String[] values, Connection connection) throws Exception {
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            Caracteristique[] caracteristiques = this.caracteriser(values, connection);
            for (Caracteristique caracteristique : caracteristiques) {
                this.ajouter(caracteristique, connection);
            }

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
    }

    public void ajouter(String idBien, String[] values, Connection connection) throws Exception {
        Bien bien = new Bien();
        bien.setId(idBien);
        bien.ajouter(values, connection);
    }

    public Composant[] getComposants(String mere, Connection connection) throws Exception {
        Composant composant = new Composant();
        String sql ="SELECT *\r\n" +
                    "FROM V_COMPOSANT_ETAT_HIERARCHIE\r\n" +
                    "WHERE code = '%s' AND mere %s ORDER BY nom, id_composant";
        mere = (mere == null) ? "is NULL" : "= '" + mere + "'";
        return (Composant[]) composant.getData(String.format(sql, this.getCode(), mere), connection);
    }

    public Composant[] getAlertes(Connection connection) throws Exception {
        Composant composant = new Composant();
        composant.setTable("v_alerte");
        composant.setBien(this);
        return (Composant[]) composant.findAll(connection, "nom, id_composant");
    }

    public Inventaire faireInventaire(String date, Connection connection) throws Exception {
        boolean connect = false;
        Inventaire inventaire = new Inventaire();
        inventaire.setDate(date);
        Statement statement = null;
        ResultSet resultSet = null;
        String tmp = "";
        String sql = "SELECT * FROM v_composant_inventaire WHERE id_immobilisation = '%s'";
        List<Composant> meres = new ArrayList<>();
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            this.setTable("v_bien");
            Bien bien = (Bien) this.getById(connection);
            if (bien == null) {
                throw new IllegalArgumentException(String.format("Le bien de code %s n'existe pas", this.getCode()));
            }

            inventaire.setBien(bien);
            statement = connection.createStatement();
            resultSet = statement.executeQuery(String.format(sql, bien.getImmobilisation().getId()));
            List<Composant> filles = new ArrayList<>();
            Composant mere = null;
            while (resultSet.next()) {
                if (!tmp.equals(resultSet.getString(1))) {
                    if (mere != null) {
                        mere.setComposants(filles.toArray(new Composant[0]));
                        filles.clear();
                    }
                    mere = new Composant();
                    mere.setId(resultSet.getString(1));
                    mere.setNom(resultSet.getString(2));
                    mere.setAlerte(resultSet.getDouble(3));
                    mere.setBien(bien);
                    meres.add(mere);
                    tmp = mere.getId();
                }
                Composant fille = new Composant();
                fille.setBien(bien);
                fille.setId(resultSet.getString(4));
                fille.setNom(resultSet.getString(5));
                fille.setCapacite(resultSet.getDouble(7));
                fille.setUnite(resultSet.getString(8));
                filles.add(fille);
                if (mere != null) {
                    mere.setComposants(filles.toArray(new Composant[0]));
                }
            }
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connect) {
                connection.close();
            }
        }
        inventaire.setComposants(meres.toArray(new Composant[0]));
        return inventaire;
    }

    public Inventaire faireInventaire(String idBien, String date, Connection connection) throws Exception {
        Bien bien = new Bien();
        bien.setCode(idBien);
        return bien.faireInventaire(date, connection);
    }

}