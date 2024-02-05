<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.bien.Bien" %>
<%@page import="model.caracteristique.Caracteristique" %>
<%@page import="model.bien.Dashboard" %>
<%@page import="model.mission.Mission" %>
<%@page isErrorPage="true" %>
<%
    
    String code = (request.getParameter("bien") == null) ? "012020242182AMBA00014" : request.getParameter("bien");
    Dashboard dashboard = new Dashboard().getDashboard(code, null);
    Bien bien = dashboard.getBien();
    Mission[] missions = dashboard.getMissions();
    String error = (exception == null) ? "" : exception.getMessage();

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/style.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/header.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/dashboard.css">
    <title>Dashboard</title>
    <style>
        .sticky-offset {
            top: 20px;
        }

        .red {
            accent-color: red;
        }
        .green {
            accent-color: green;
        }
        
        .yellow {
            accent-color: yellow;
        }

        #map {
            -webkit-border-radius:20px;
            z-index:0;
        }

        .badge {
            color: white;
            padding: 4px 8px;
            text-align: center;
            border-radius: 5px;
        }
    </style>
    <script>
    
        window.addEventListener("load", () => {
            
            let map;
            let marker;

            async function initMap() {
                const position = { lat: -18.9162618, lng: 47.5128566 };
                const { Map } = await google.maps.importLibrary("maps");

                let markers = [];

                map = new Map(document.getElementById("map"), {
                    zoom: 12,
                    center: position,
                    mapId: "DEMO_MAP_ID",
                });

                // Create some markers on the map
                let locations = [
                    <% for (Mission mission : missions) { %>
                    [<%=mission.getLongitude() %>, <%=mission.getLatitude() %>],
                    <% } %>
                ];

                locations.forEach(([lng, lat]) => {
                    <% for (Mission mission : missions) { %>
                    addMarker(new google.maps.LatLng({ lat, lng }), '<%=mission.getEmployee().getPrenomNom() %>\n<%=mission.getDebut() %>');
                    <% } %>
                });
            }


            function addMarker(location, content) {
                marker = new google.maps.Marker({
                    position: location,
                    map: map
                });

                var infowindow = new google.maps.InfoWindow();
                infowindow.setContent(content);

                makeInfoWindowEvent(infowindow, marker);
            }

            function makeInfoWindowEvent(infowindow, marker) {
                google.maps.event.addListener(marker, 'click', function() {
                    infowindow.open(map, marker);
                });
            }

            initMap();
            
        });

    </script>
</head>
<body>
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="./header.html" />


            <div class="col my-4 mx-4 min-vh-100">
                <div class="row p-4 bg-light detail w-75 mx-auto">
                    <div class="col p-2 d-flex">
                        <div class="col">
                            <img src="/immobilisation/assets/img/peakpx.jpg" alt="" srcset="">
                            <h4 class="mt-4">Etat : <%=bien.getComportement() %></h4>
                        </div>
                        <div class="col ms-5">
                            <button type="button" class="position-relative float-end btn btn-outline-warning" style="border-radius: 20px">
                                <i class="bi bi-bell fs-3"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="border-raduis: 20px">
                                    <%=bien.getAlerteFormat() %>
                                    <span class="visually-hidden">unread messages</span>
                                </span>
                            </button>
                            <h3>Caracteristique</h3>
                            <ul>
                                <li>Nom : <%=bien.getNom() %></li>
                                <li>Marque : <%=bien.getMarque().getNom() %></li>
                                <% for (Caracteristique caracteristique : bien.getCaracteristiques()) { %>
                                <li><%=caracteristique.getNom() %> : <%=caracteristique.getValeur() %></li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col bg-light detail w-75 mx-auto mt-4 p-5">
                    <div class="col">
                        <div id="map" style="width:100%;height:500px;"></div>
                    </div>
                    <div class="col mt-4">
                        <h2 class="text-center">Liste des missions</h2>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Employee</th>
                                    <th>Lieu</th>
                                    <th>Debut</th>
                                    <th>Fin</th>
                                    <th>Evenement</th>
                                    <th>Status</th>
                                    <th>Bilan</th>
                                    <th>Valider</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Mission mission : missions) { %>
                                <tr>
                                    <td class="align-center-middle"><%=mission.getId() %></td>
                                    <td class="align-center-middle"><%=mission.getEmployee().getPrenomNom() %></td>
                                    <td class="align-center-middle"><%=mission.getAdresse() %></td>
                                    <td class="align-center-middle"><%=mission.getDebut() %></td>
                                    <td class="align-center-middle"><%=mission.getFinString() %></td>
                                    <td class="align-center-middle"><span class="badge" style="background-color: <%=mission.getStatusColor() %>;"><%=mission.getStatusLabel() %></span></td>
                                    <td class="align-center-middle"><span class="badge" style="background-color: <%=mission.getEtatColor() %>;"><%=mission.getEtatLabel() %></span></td>
                                    <td class="align-center-middle">
                                    <% if (mission.enCours()) { %>
                                        <a href="/immobilisation/controller/bilan/bilan.jsp?mission=<%=mission.getId() %>"><i style="color: rgb(0, 0, 0);" class="bi-newspaper fs-4"></i></a>
                                    <% } %>
                                    </td>
                                    <td class="align-center-middle">
                                        <a href="/immobilisation/controller/validation/valider.jsp?mission=<%=mission.getId() %>"><i style="color: rgb(0, 0, 0);" class="bi-check fs-4"></i></a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <h3 class="text-danger"><%=error %></h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAtBfUgArg9M-eu4m9ilh1G3n1hwyTozJw&callback=initMap"></script>
</body>
</html>