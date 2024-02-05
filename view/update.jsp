<%@page import="model.composant.Composant" %>
<%@page import="model.inventaire.Inventaire" %>
<%
    
    Inventaire inventaire = (Inventaire) session.getAttribute("bilan");
    int index = Integer.parseInt(request.getParameter("i"));
    Composant composant = inventaire.getComposants()[index];

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


                        <form class="p-5 w-50 bg-white detail" action="/immobilisation/controller/bilan/update.jsp" method="GET">
                            <h2 class="text-center mb-4">Modification</h2>
                            <div class="mb-3">
                                <label for="date" class="form-label">Valeur</label>
                                <input type="text" class="form-control" name="valeur" value="<%=composant.getEtatReel() %>">
                            </div>
                            <input type="hidden" name="i" value="<%=index %>">
                            <input type="hidden" name="mission" value="<%=request.getParameter("mission") %>">
                            <button type="submit" class="btn btn-outline-dark px-5 mt-3">Valider</button>
                        </form>
                    
                    
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>