/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Vehicles.Vehicles;
import Database.vehicleDAO;

/**
 *
 * @author nadhi
 */

public class AddVehicleServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet addVehicleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addVehicleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Vehicles v = new Vehicles();
        v.setModel(request.getParameter("model"));
        v.setBrand(request.getParameter("brand"));
        v.setManufacturingYear(Integer.parseInt(request.getParameter("manufacturingYear")));
        v.setAvailability(Boolean.parseBoolean(request.getParameter("availability")));
        v.setCategory(request.getParameter("category"));
        v.setFuelType(request.getParameter("fuelType"));
        v.setTransmissionType(request.getParameter("transmissionType"));
        v.setMileage(Integer.parseInt(request.getParameter("mileage")));
        v.setRatePerDay(Double.parseDouble(request.getParameter("ratePerDay")));
        v.setRegistrationNo(request.getParameter("registrationNo"));
        v.setVehicleImagePath(request.getParameter("vehicleImagePath"));

        int status = vehicleDAO.add(v);
        if (status > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-vehicles.jsp?message=Vehicle+added+successfully&type=success");
        } else {
            request.setAttribute("error", "Failed to add vehicle.");
            request.getRequestDispatcher(request.getContextPath() + "/admin/admin-vehicles.jsp").forward(request, response);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
