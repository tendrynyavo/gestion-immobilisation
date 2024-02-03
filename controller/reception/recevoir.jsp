<%@page import="model.reception.Reception" %>
<%@page import="model.bien.Bien" %>
<%

    Bien bien = new Reception().recevoir(request.getParameter("immobilisation"), request.getParameter("date"), request.getParameter("adresse"), request.getParameter("designation"), request.getParameter("marque"), null);
    response.sendRedirect("/immobilisation/detail.jsp?bien=" + bien.getId());

%>