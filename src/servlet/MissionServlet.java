package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.mission.Mission;

@MultipartConfig
public class MissionServlet extends HttpServlet {
    
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
        PrintWriter out = response.getWriter();
        try {
            new Mission().utiliser(request.getParameter("employee"), request.getParameter("bien"), request.getParameter("debut"), request.getParameter("longitude"), request.getParameter("latitude"));
            response.setStatus(200);
        } catch (Exception e) {
            response.setStatus(500);
            out.print(e.getMessage());
        }
    }

}
