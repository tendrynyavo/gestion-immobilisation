package model.mission;

import java.sql.Connection;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import connection.BddObject;
import connection.Column;
import model.bien.Bien;
import model.composant.Composant;
import model.employee.Employee;
import model.inventaire.Inventaire;
import model.map.GeoMap;

public class Mission extends GeoMap {

    Employee employee;
    Bien bien;
    String adresse;
    Inventaire actuelle;
    Timestamp debut;
    Timestamp fin;
    Inventaire inventaire;
    Integer etat;

    public Integer getEtat() {
        return etat;
    }

    public void setEtat(Integer etat) {
        this.etat = etat;
    }

    public void setEtat(String etat) {
        if (etat == null) {
            this.setEtat((Integer) null);
        } else {
            this.setEtat(Integer.parseInt(etat));
        }
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public Inventaire getActuelle() {
        return actuelle;
    }

    public void setActuelle(Inventaire actuelle) {
        this.actuelle = actuelle;
    }

    public Timestamp getDebut() {
        return debut;
    }

    public void setDebut(String debut) throws IllegalArgumentException, ParseException {
        if (debut.isEmpty())
            throw new IllegalArgumentException("Debut est vide");
        this.setDebut(toDate(debut));
    }

    public void setDebut(Timestamp debut) {
        this.debut = debut;
    }

    public Timestamp getFin() {
        return fin;
    }

    public String getFinString() {
        return (this.getFin() == null) ? "-" : this.getFin().toString();
    }

    public void setFin(String fin) throws IllegalArgumentException, ParseException {
        if (fin.isEmpty())
            throw new IllegalArgumentException("Fin est vide");
        this.setFin(toDate(fin));
    }

    public void setFin(Timestamp fin) {
        this.fin = fin;
    }

    public Inventaire getInventaire() {
        return inventaire;
    }

    public void setInventaire(Inventaire inventaire) {
        this.inventaire = inventaire;
    }

    public boolean enCours() {
        return this.getEtat() == 10 && this.getDebut().before(new Timestamp(System.currentTimeMillis())) && this.getFin() == null;
    }

    public int getStatus() {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        if (this.getDebut().before(timestamp) && !this.enCours()) {
            return -1;
        } else if (this.getDebut().after(timestamp)) {
            return 1;    
        } else {
            return 0;
        }
    }

    public String getStatusColor() {
        String color = "";
        switch (this.getStatus()) {
            case -1:
                color = "#582900";
                break;

            case 0:
                color = "green";
                break;

            case 1:
                color = "#87CEEB";
                break;
        
            default:
                break;
        }
        return color;
    }

    public String getEtatLabel() {
        String label = "";
        switch (this.getEtat()) {
            case 0:
                label = "Non validee";
                break;

            case 10:
                label = "Validee";
                break;

            case 20:
                label = "Confirmee";
                break;
        
            default:
                break;
        }
        return label;
    }

    public String getEtatColor() {
        String label = "";
        switch (this.getEtat()) {
            case 0:
                label = "#582900";
                break;

            case 10:
                label = "green";
                break;

            case 20:
                label = "red";
                break;
        
            default:
                break;
        }
        return label;
    }

    public String getStatusLabel() {
        String color = "";
        switch (this.getStatus()) {
            case -1:
                color = "Passee";
                break;

            case 0:
                color = "En cours";
                break;

            case 1:
                color = "Future";
                break;
        
            default:
                break;
        }
        return color;
    }

    public Mission() throws Exception {
        super();
        this.setTable("v_mission");
        this.setConnection("Oracle");
        this.setPrimaryKeyName("id_mission");
        this.setPrefix("MI");
        this.setCountPK(6);
        this.setFunctionPK("seq_mission.NEXTVAL");
    }

    public static Timestamp toDate(String date) throws IllegalArgumentException, ParseException {
        // Format date in client-side is YYYY-MM-ddThh:mm
        date = date.replace("T", ",").replace(" ", ",");
        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd,HH:mm");
        Date date2 = formatter.parse(date);
        return new Timestamp(date2.getTime());
    }

    public Mission utiliser(String idEmployee, String idBien, String debut, String longitude, String latitude) throws Exception {
        Employee employee = new Employee();
        employee.setId(idEmployee);
        Mission mission = null;
        try (Connection connection = this.getConnection()) {
            mission = employee.utiliser(idBien, debut, longitude, latitude, connection);
            mission.insert(connection);
            connection.commit();
        }
        return mission;
    }

    public Validation valider(Connection connection) throws Exception {
        boolean connect = false;
        Validation validation = new Validation();
        try {
            
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            Mission mission = (Mission) this.getById(connection);
            if (mission == null) {
                throw new IllegalArgumentException("Mission n'existe pas");
            }

            if (mission.getStatus() != 1) {
                throw new IllegalAccessException("Mission doit etre dans l'avenir");
            }

            this.setBien(mission.getBien());

            // Vérification des missions en cours
            Mission[] missions = this.getBien().getMissionsEnCours(connection);
            if (missions.length > 0) {
                throw new IllegalArgumentException("Il y a encore des missions en cours");
            }

            // Get Last Inventaire pour avoir l'état actuelle
            Composant[] composants = this.getBien().getEtatActuelleComposantsFille(connection);

            validation.setMission(mission);
            validation.setDate(new Timestamp(System.currentTimeMillis()));
            validation.setComposants(composants);
        } finally {
            if (connect) {
                connection.close();
            }
        }
        return validation;
    }

    public Inventaire generate(Connection connection) throws Exception {
        boolean connect = false;
        Inventaire inventaire = new Inventaire();
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            Mission mission = (Mission) this.getById(connection);
            if (mission == null) {
                throw new IllegalArgumentException("Mission n'existe pas");
            }

            this.setBien(mission.getBien());

            Composant[] composants = this.getBien().getEtatActuelleComposantsFille(connection);
            inventaire.setBien(this.getBien());
            inventaire.setComposants(composants);
            inventaire.setDate(new Timestamp(System.currentTimeMillis()));
        } finally {
            if (connect) {
                connection.close();
            }
        }
        return inventaire;
    }

    public void confirmer(Inventaire inventaire, Connection connection) throws Exception {
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }
            
            inventaire.confirmer(connection);
    
            this.setFunctionPK("seq_fin_mission.NEXTVAL");
            this.setPrefix("F");
            this.setCountPK(4);
            
            Mission mission = new Mission();
            mission.setSerial(false);
            mission.setId(this.getId());
            mission.setInventaire(inventaire);
            mission.setFin(new Timestamp(System.currentTimeMillis()));
            mission.setTable("fin_mission");
            mission.insert(connection, new Column("id_fin_mission", this.getSequence().buildPrimaryKey(connection)));

            this.changerEtat(20, connection);

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

    public void changerEtat(int etat, Connection connection) throws Exception {
        // Mise à jour du status de la mission
        Mission update = new Mission();
        update.setTable("mission");
        update.setId(this.getId());
        update.setEtat(etat);
        update.update(connection);
    }

    public static void main(String[] args) throws Exception {
        Mission mission = new Mission();
        mission.setId("MI0016");
        try (Connection connection = BddObject.getOracle()) {
            Inventaire inventaire = mission.generate(connection);
            mission.confirmer(inventaire, connection);
            connection.commit();
        }
    }

}