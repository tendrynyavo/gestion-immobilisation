<%@page import="model.immobilisation.Immobilisation" %>
<%@page import="model.adresse.Adresse" %>
<%@page import="java.util.Map" %>
<%

    Map<String, Object> data = new Immobilisation().getDropDown();
    Immobilisation[] immobilisations = (Immobilisation[]) data.get("immobilisations");
    Adresse[] adresses = (Adresse[]) data.get("adresses");

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
    <link rel="stylesheet" href="/immobilisation/assets/css/reception.css">
    <title>Dashboard</title>
    <style>
        .sticky-offset {
            top: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="./header.html" />


            <div class="col my-4 mx-4 min-vh-100">
                <div class="row">
                    <div class="col">


                        <form class="p-5 w-50 bg-white detail" action="/immobilisation/bien.jsp" method="GET">
                            <h2 class="text-center mb-4">Procés verbale de reception</h2>
                            <div class="mb-3">
                                <label for="magasin" class="form-label">Immobilisation</label>
                                <select class="form-select" name="immobilisation">
                                    <% for (Immobilisation immobilisation : immobilisations) { %>
                                    <option value="<%=immobilisation.getId() %>"><%=immobilisation.getNom() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="date" class="form-label">Date</label>
                                <input type="date" class="form-control" name="date">
                            </div>
                            <div class="mb-3">
                                <label for="magasin" class="form-label">Adresse</label>
                                <select class="form-select" name="adresse">
                                    <% for (Adresse adresse : adresses) { %>
                                    <option value="<%=adresse.getId() %>"><%=adresse.getNom() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-outline-dark px-5 mt-3">Valider</button>
                        </form>
                    
                    
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>