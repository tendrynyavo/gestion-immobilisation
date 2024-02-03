<%@page import="model.inventaire.Inventaire" %>
<%

    Inventaire inventaire = (Inventaire) session.getAttribute("inventaire");
    inventaire.insert(null);
    response.sendRedirect(String.format("/immobilisation/dashboard.jsp?bien=%s", inventaire.getBien().getCode()));

%>