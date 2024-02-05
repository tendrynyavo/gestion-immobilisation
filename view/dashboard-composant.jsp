<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="model.bien.Bien" %>
<%@page import="model.caracteristique.Caracteristique" %>
<%@page import="model.bien.Dashboard" %>
<%@page import="model.composant.Composant" %>
<%
    
    Dashboard dashboard = new Dashboard().getDashboard(request.getParameter("bien"), request.getParameter("mere"), null);
    Bien bien = dashboard.getBien();
    Composant[] componsants = dashboard.getComposants();

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
                    <h2 class="text-center">Liste des componsants</h2>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Designation</th>
                                <th>Reste</th>
                                <th>Etat</th>
                                <th>Progression</th>
                                <th>Etat (%)</th>
                                <th>Last inventaire</th>
                                <th></th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Composant componsant : componsants) { %>
                            <tr>
                                <td class="align-center-middle"><%=componsant.getId() %></td>
                                <td class="align-center-middle"><%=componsant.getNom() %></td>
                                <td class="align-center-middle text-center"><%=componsant.getReste() %></td>
                                <td class="align-center-middle"><%=componsant.getComportement() %></td>
                                <td class="align-center-middle"><progress class="<%=componsant.getColor() %>" value="<%=componsant.getPourcentage() %>" max="100"></progress></td>
                                <td class="align-center-middle"><%=componsant.getPourcentageFormat() %>%</td>
                                <td class="align-center-middle"><%=componsant.getLastInventaireString() %></td>
                                <td class="align-center-middle">
                                <% if (!componsant.isFille()) { %>
                                <a href="/immobilisation/dashboard-composant.jsp?bien=<%=bien.getCode() %>&mere=<%=componsant.getId() %>"><i style="color: rgb(0, 0, 0);" class="bi-arrow-90deg-right fs-4"></i></a>
                                <% } %>
                                </td>
                                <td class="align-center-middle"><i style="color: rgb(0, 0, 0);" class="bi-bag-plus fs-4"></i></td>
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