<%@page import="model.employee.Employee" %>
<%@page import="model.bien.Bien" %>
<%

    Employee[] employees = (Employee[]) new Employee().findAll(null);
    Bien[] biens = (Bien[]) new Bien().findAll(null);

%>
<!DOCTYPE html>
<html>
  <head>
    <title>Mission</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/style.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/header.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/dashboard.css">
  </head>
    <style>
    
        #map {
            height: 100%;
            width: 50%;
        }
        
        /* 
        * Optional: Makes the sample page fill the window. 
        */
        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
  
    </style>

    <script>
    
        window.addEventListener("load", () => {
            
            let map;
            var form = document.getElementById("form");
            let marker;

            async function initMap() {
                const position = { lat: -18.9162618, lng: 47.5128566 };
                const { Map } = await google.maps.importLibrary("maps");

                map = new Map(document.getElementById("map"), {
                    zoom: 12,
                    center: position,
                    mapId: "DEMO_MAP_ID",
                });

                map.addListener('click', (e) => {
                    placeMarker(e.latLng);
                });
            }


            function placeMarker(position) {
                if (marker) {
                    marker.setPosition(position);
                } else {
                    marker = new google.maps.Marker({
                    position: position,
                    map: map
                    });
                }
            }

            function sendData() {
                var xhr; 
                
                try {  xhr = new ActiveXObject('Msxml2.XMLHTTP');   }
                catch (e) 
                {
                    try {   xhr = new ActiveXObject('Microsoft.XMLHTTP'); }
                    catch (e2) 
                    {
                        try {  xhr = new XMLHttpRequest();  }
                        catch (e3) {  xhr = false;   }
                    }
                }

                // Liez l'objet FormData et l'élément form
                var formData = new FormData(form);

                formData.append("longitude", marker.getPosition().lng());
                formData.append("latitude", marker.getPosition().lat());

                // Définissez ce qui se passe si la soumission s'est opérée avec succès
                xhr.addEventListener("load", (event) => {
                    let msg = (event.target.responseText != "") ? event.target.responseText : "La mission a été ajoutée";
                    alert(msg);
                });

                // Definissez ce qui se passe en cas d'erreur
                xhr.addEventListener("error", (event) => {
                    alert('Oups! Quelque chose s\'est mal passé.');
                });

                // Configurez la requête
                xhr.open("POST", "mission");

                // Les données envoyées sont ce que l'utilisateur a mis dans le formulaire
                xhr.send(formData);
            }

            form.addEventListener("submit", (event) => {
                event.preventDefault(); // évite de faire le submit par défaut

                sendData();
            });

            initMap();
            
        });
    </script>

  <body>
    
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="./header.html" />
            

            <div class="col my-4 mx-4 min-vh-100">
                <div class="row">
                    
                    <div class="col p-4 bg-white detail" style="border-radius: 20px">
                        <div id="map" style="width:100%;height:500px;"></div>
                    </div>

                    <div class="col">
                        <form class="p-5 bg-white detail" id="form">
                            <h2 class="text-center mb-4">Mission à accomplir</h2>
                            <div class="mb-3">
                                <label for="magasin" class="form-label">Employee</label>
                                <select class="form-select" name="employee">
                                    <% for (Employee employee : employees) { %>
                                    <option value="<%=employee.getId() %>"><%=employee.getPrenom() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="magasin" class="form-label">Bien</label>
                                <select class="form-select" name="bien">
                                    <% for (Bien bien : biens) { %>
                                    <option value="<%=bien.getCode() %>"><%=bien.getNom() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="date" class="form-label">Debut</label>
                                <input type="datetime-local" class="form-control" name="debut">
                            </div>
                            <button type="submit" class="btn btn-outline-dark px-5 mt-3">Valider</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAtBfUgArg9M-eu4m9ilh1G3n1hwyTozJw&callback=initMap"></script>
  </body>
</html>