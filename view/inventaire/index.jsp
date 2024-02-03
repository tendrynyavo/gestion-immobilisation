<%@page import="model.bien.Bien" %>
<%

    Bien[] biens = (Bien[]) new Bien().findAll(null);

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


                        <form class="p-5 w-50 bg-white detail" action="/immobilisation/controller/inventaire/" method="GET">
                            <h2 class="text-center mb-4">Inventaire</h2>
                            <div class="mb-3">
                                <label for="magasin" class="form-label">Bien</label>
                                <select class="form-select" name="bien">
                                    <% for (Bien bien : biens) { %>
                                    <option value="<%=bien.getCode() %>"><%=bien.getCode() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="date" class="form-label">Date</label>
                                <input type="date" class="form-control" name="date">
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