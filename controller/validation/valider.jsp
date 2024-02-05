<%@page import="model.mission.Mission" %>
<%@page import="model.mission.Validation" %>
<%

    Validation validation = new Validation().valider(request.getParameter("mission"));
    response.sendRedirect(String.format("/immobilisation/dashboard-mission.jsp?bien=%s", validation.getMission().getBien().getCode()));

%>