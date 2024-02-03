<%@page import="model.bien.Bien" %>
<%

    new Bien().ajouter(request.getParameter("bien"), request.getParameterValues("caracteristiques"), null);
    response.sendRedirect("/immobilisation/reception.jsp");

%>