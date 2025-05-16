/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Booking.Booking;
import Database.DatabaseCRUD;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Naim Najmi
 */
public class VehicleBookingServlet extends HttpServlet {

    // Logger to log the messages
    private static final Logger LOGGER = Logger.getLogger(VehicleBookingServlet.class.getName());
    // Add the booking to the database
    DatabaseCRUD databaseCRUD;

    public VehicleBookingServlet() throws SQLException, ClassNotFoundException {
        this.databaseCRUD = new DatabaseCRUD();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {

        // Get the booking details from the request
        String clientID = request.getParameter("clientID");
        String vehicleID = request.getParameter("vehicleID");
        String assignedDate = request.getParameter("assignedDate");
        String bookingDate = request.getParameter("bookingDate");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String totalCost = request.getParameter("totalCost");
        String bookingStatus = "Pending";
        String createdBy = request.getParameter("createdBy");

        // Create a new booking object
        Booking booking = new Booking(clientID, vehicleID, assignedDate, bookingDate, startDate, endDate, totalCost,
                bookingStatus, createdBy);

        // Log the booking details
        LOGGER.info("Booking details: " + booking);

        boolean isBookingAdded = databaseCRUD.addBooking(booking);

        if (isBookingAdded) {
            // Log the success message
            LOGGER.info("Booking added successfully");
            // Redirect to the booking confirmation page
            response.sendRedirect("booking-confirmation.jsp");
        } else {
            // Log the failure message
            LOGGER.severe("Booking addition failed");
            // Redirect to the booking failure page
            response.sendRedirect("booking-failure.jsp");
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(VehicleBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(VehicleBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(VehicleBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(VehicleBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
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
