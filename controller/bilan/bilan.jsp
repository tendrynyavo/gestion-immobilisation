<%@page import="model.inventaire.Inventaire" %>
<%@page import="model.mission.Mission" %>
<%

    Mission mission = new Mission();
    mission.setId(request.getParameter("mission"));
    Inventaire inventaire = mission.generate(null);
    session.setAttribute("bilan", inventaire);
    response.sendRedirect("/immobilisation/bilan.jsp?mission=" + mission.getId());

%>