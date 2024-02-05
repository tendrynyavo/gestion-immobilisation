package model.bien;

import java.sql.Connection;
import connection.BddObject;
import model.composant.Composant;
import model.mission.Mission;

public class Dashboard {
    
    Bien bien;
    Composant[] composants;
    Mission[] missions;

    public Mission[] getMissions() {
        return missions;
    }

    public void setMissions(Mission[] missions) {
        this.missions = missions;
    }

    public Bien getBien() {
        return bien;
    }

    public void setBien(Bien bien) {
        this.bien = bien;
    }

    public Composant[] getComposants() {
        return composants;
    }

    public void setComposants(Composant[] composants) {
        this.composants = composants;
    }

    public Dashboard getDashboard(String idBien, String mere, Connection connection) throws Exception {
        boolean connect = false;
        Dashboard dashboard = new Dashboard();
        try {
            if (connection == null) {
                connection = BddObject.getOracle();
                connect = true;
            }
            Bien bien = new Bien().detail(idBien, true, connection);
            dashboard.setBien(bien);
            dashboard.setComposants(bien.getEtatActuelleComposants(mere, connection));
        } finally {
            if (connect) {
                connection.close();
            }
        }
        return dashboard;
    }

    public Dashboard getDashboard(String idBien, Connection connection) throws Exception {
        boolean connect = false;
        Dashboard dashboard = new Dashboard();
        try {
            if (connection == null) {
                connection = BddObject.getOracle();
                connect = true;
            }
            Bien bien = new Bien().detail(idBien, true, connection);
            dashboard.setBien(bien);
            dashboard.setMissions(bien.getMissions(null, connection));
        } finally {
            if (connect) {
                connection.close();
            }
        }
        return dashboard;
    }

}