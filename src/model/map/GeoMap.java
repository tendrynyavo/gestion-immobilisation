package model.map;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class GeoMap {

    double longitude;
    double latitude;

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.setLongitude(Double.valueOf(longitude));
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.setLatitude(Double.valueOf(latitude));
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public String getAddress() throws IOException {
        String key = "AIzaSyAtBfUgArg9M-eu4m9ilh1G3n1hwyTozJw";
        String api = "https://maps.googleapis.com/maps/api/geocode/json?latlng=%s,%s&result_type=administrative_area_level_4&key=%s";
        URL url = new URL(String.format(api, this.getLatitude(), this.getLongitude(), key));
        HttpURLConnection con = null;
        String adresse = null;
        try {
            con = (HttpURLConnection) url.openConnection();
            
            int responseCode = con.getResponseCode();
    
            if (responseCode != HttpURLConnection.HTTP_OK && responseCode != 201) {
                throw new IllegalCallerException("API request failed with response code: " + responseCode);
            }
    
            StringBuilder response = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
                String line;
    
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
            }
            String value = response.toString();
            String[] adresses = value.split("formatted_address");
            adresse = adresses[1].split("\"")[2];
        } finally {
            if (con != null) {
                con.disconnect();
            }
        }
        return adresse;
    }

}
