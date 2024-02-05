<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="model.composant.Composant" %>
<%@page import="model.inventaire.Inventaire" %>
<%
    
    Inventaire inventaire = (Inventaire) session.getAttribute("bilan");
    Composant[] composants = inventaire.getComposants();

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
                <div class="col bg-light detail w-75 mx-auto mt-4 p-5">
                    <h2 class="text-center">Bilan de la mission</h2>
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
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < composants.length; i++) { %>
                            <tr>
                                <td class="align-center-middle"><%=composants[i].getId() %></td>
                                <td class="align-center-middle"><%=composants[i].getNom() %></td>
                                <td class="align-center-middle text-center"><%=composants[i].getReste() %></td>
                                <td class="align-center-middle"><%=composants[i].getComportement() %></td>
                                <td class="align-center-middle"><progress class="<%=composants[i].getColor() %>" value="<%=composants[i].getPourcentage() %>" max="100"></progress></td>
                                <td class="align-center-middle"><%=composants[i].getPourcentageFormat() %>%</td>
                                <td class="align-center-middle"><%=composants[i].getLastInventaireString() %></td>
                                <td class="align-center-middle">
                                <a href="/immobilisation/update.jsp?i=<%=i %>&mission=<%=request.getParameter("mission") %>">
                                    <i style="color: rgb(0, 0, 0);" class="bi-arrow-clockwise fs-4"></i>
                                </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <a href="/immobilisation/controller/bilan/confirmer.jsp?mission=<%=request.getParameter("mission") %>">
                        <button type="submit" class="btn btn-outline-dark px-5 mt-3">Confirmer</button>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>