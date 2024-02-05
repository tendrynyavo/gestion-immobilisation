<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="model.bien.Bien" %>
<%@page import="model.immobilisation.Immobilisation" %>
<%
    
    Immobilisation[] immobilisations = (Immobilisation[]) new Immobilisation().findAll(null);
    Immobilisation immobilisation = new Immobilisation();
    immobilisation.setId(request.getParameter("immobilisation"));
    Bien[] biens = immobilisation.getEtatBien(null);

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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="./header.html" />


            <div class="col my-4 mx-4 min-vh-100">
                 <div class="col d-flex justify-content-center">


                    <form class="p-5 w-50 bg-white detail" action="/immobilisation/list-bien.jsp" method="GET">
                        <div class="mb-3">
                            <label for="magasin" class="form-label">Immobilisation</label>
                            <select class="form-select" name="immobilisation">
                                <% for (Immobilisation list : immobilisations) { %>
                                <option value="<%=list.getId() %>"><%=list.getNom() %></option>
                                <% } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-outline-dark px-5 mt-3">Valider</button>
                    </form>
                
                
                </div>
                <div class="col bg-light detail mx-auto mt-4 p-5">
                    <h2 class="text-center">Liste des biens</h2>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Marque</th>
                                <th>Designation</th>
                                <th>Date de reception</th>
                                <th>Etat</th>
                                <th>Progression</th>
                                <th>Alerte</th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Bien bien : biens) { %>
                            <tr>
                                <td class="align-center-middle"><%=bien.getCode() %></td>
                                <td class="align-center-middle"><%=bien.getMarque().getNom() %></td>
                                <td class="align-center-middle"><%=bien.getNom() %></td>
                                <td class="align-center-middle text-center"><%=bien.getDate() %></td>
                                <td class="align-center-middle text-center"><%=bien.getComportement() %></td>
                                <td class="align-center-middle"><progress class="<%=bien.getColor() %>" value="<%=bien.getPourcentage() %>" max="100"></progress></td>
                                <td class="align-center-middle"><%=bien.getAlerte() %></td>
                                <td class="align-center-middle">
                                    <a href="/immobilisation/dashboard-composant.jsp?bien=<%=bien.getCode() %>"><i style="color: rgb(0, 0, 0);" class="bi-arrow-90deg-right fs-4"></i></a>
                                </td>
                                <td class="align-center-middle">
                                    <a href="/immobilisation/dashboard-mission.jsp?bien=<%=bien.getCode() %>"><i style="color: rgb(0, 0, 0);" class="bi-arrow-90deg-right fs-4"></i></a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>