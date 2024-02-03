<%@page import="model.inventaire.Inventaire" %>
<%@page import="model.inventaire.InventaireDoneException" %>
<%

    Inventaire inventaire = null;
    try {
        inventaire = (Inventaire) session.getAttribute("inventaire");
        inventaire.ajouter(request.getParameterValues("composants"), request.getParameter("i"));
        int index = Integer.parseInt(request.getParameter("i"));
        response.sendRedirect(String.format("/immobilisation/inventaire/detail.jsp?i=%s", index + 1));
    } catch (InventaireDoneException e) {
        response.sendRedirect(String.format("/immobilisation/dashboard.jsp?bien=", inventaire.getBien().getCode()));
    }

%>