<%@page import="model.inventaire.Inventaire" %>
<%@page import="model.bien.Bien" %>
<%

    Inventaire inventaire = new Bien().faireInventaire(request.getParameter("bien"), request.getParameter("date"), null);
    session.setAttribute("inventaire", inventaire);
    response.sendRedirect("/immobilisation/inventaire/detail.jsp?i=0");

%>