<%@page import="model.composant.Composant" %>
<%@page import="model.inventaire.Inventaire" %>
<%
    
    Inventaire inventaire = (Inventaire) session.getAttribute("bilan");
    int index = Integer.parseInt(request.getParameter("i"));
    Composant composant = inventaire.getComposants()[index];
    composant.changerEtat(request.getParameter("valeur"));

    response.sendRedirect("/immobilisation/bilan.jsp?mission=" + request.getParameter("mission"));

%>