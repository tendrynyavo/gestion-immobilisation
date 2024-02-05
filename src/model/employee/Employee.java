package model.employee;

import java.sql.Connection;
import connection.BddObject;
import model.bien.Bien;
import model.map.GeoMap;
import model.mission.Mission;

public class Employee extends BddObject {

    String nom;
    String prenom;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getPrenomNom() {
        return this.getNom() + " " + this.getPrenom();
    }

    public Employee() throws Exception {
        super();
        this.setTable("employee");
        this.setPrefix("EMP");
        this.setConnection("Oracle");
        this.setPrimaryKeyName("id_employee");
    }

    public Mission utiliser(String idBien, String debut, String longitude, String latitude, Connection connection) throws Exception {
        // Test unitaire
        Mission mission = new Mission();
        mission.setTable("mission");
        mission.setDebut(debut);
        GeoMap map = new GeoMap();
        map.setLatitude(latitude);
        map.setLongitude(longitude);
        boolean connect = false;
        try {
            if (connection == null) {
                connection = this.getConnection();
                connect = true;
            }

            // Test d'existance
            Employee employee = (Employee) new Employee().setId(this.getId()).getById(connection);
            if (employee == null) {
                throw new IllegalArgumentException("Employee n'existe pas");
            }

            Bien bien = (Bien) new Bien().setId(idBien).getById(connection);
            if (bien == null) {
                throw new IllegalArgumentException("Bien n'existe pas");
            }

            mission.setBien(bien);
            mission.setEmployee(employee);
            mission.setLongitude(map.getLongitude());
            mission.setLatitude(map.getLatitude());
            mission.setAdresse(map.getAddress());
            } finally {
            if (connect) {
                connection.close();
            }
        }
        return mission;
    }
    
}