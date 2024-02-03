<%@page import="model.inventaire.Inventaire" %>
<%@page import="model.inventaire.InventaireDoneException" %>
<%@page import="model.composant.Composant" %>
<%

    Inventaire inventaire = null;
    Composant mere = null;
    try {
        inventaire = (Inventaire) session.getAttribute("inventaire");
        mere = inventaire.get(request.getParameter("i"));
    } catch (InventaireDoneException e) {
        response.sendRedirect("/immobilisation/controller/inventaire/done.jsp");
        return;
    }

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
    <title>Inventaire</title>
    <style>
        .sticky-offset {
            top: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="../header.html" />


            <div class="col my-4 mx-4 min-vh-100">
                <div class="row">
                    <div class="col">


                        <form class="p-5 w-50 bg-white detail" action="/immobilisation/controller/inventaire/detail.jsp" method="GET">
                            <h2 class="text-center mb-4"><%=mere.getNom() %></h2>
                            <% for (Composant componsant : mere.getComposants()) { %>
                            <div class="mb-3">
                                <label for="magasin" class="form-label"><%=componsant.getLabel() %></label>
                                <% if (componsant.isConsommable()) { %>
                                <input type="text" class="form-control" name="composants">
                                <% } else { %>
                                <select class="form-select" name="composants">
                                    <option value="7">Bonne etat</option>
                                    <option value="4">Utilisable</option>
                                    <option value="2">Mauvaise etat</option>
                                </select>
                                <% } %>
                            </div>
                            <input type="hidden" name="i" value="<%=request.getParameter("i") %>">
                            <% } %>
                            <button type="submit" class="btn btn-outline-dark px-5 mt-3">Suivanr</button>
                        </form>
                    
                    
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>