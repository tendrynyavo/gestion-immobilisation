<%@page import="model.inventaire.Inventaire" %>
<%@page import="model.mission.Mission" %>
<%
    
    Inventaire inventaire = (Inventaire) session.getAttribute("bilan");
    Mission mission = new Mission();
    mission.setId(request.getParameter("mission"));
    mission.confirmer(inventaire, null);
    response.sendRedirect("/immobilisation/dashboard-mission.jsp");

%>