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
public class CreateBookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CreateBookingServlet.class.getName());
    private DatabaseCRUD databaseCRUD;

    public CreateBookingServlet() {
        this.databaseCRUD = new DatabaseCRUD();
    }

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
            out.println("<title>Servlet CreateBookingServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateBookingServlet at " + request.getContextPath() + "</h1>");
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
        // Redirect GET requests to the create booking form
        response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp");
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
        LOGGER.info("Processing booking creation request");
        
        try {
            // Get all required parameters
            String clientId = request.getParameter("clientId");
            String vehicleId = request.getParameter("vehicleId");
            String assignedDate = request.getParameter("assignedDate");
            String bookingDate = request.getParameter("bookingDate");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String totalCost = request.getParameter("totalCost");
            String bookingStatus = "Confirmed"; // Default status for admin-created bookings
            String createdBy = request.getParameter("adminId");
            String paymentType = request.getParameter("paymentType");

            // Validate required parameters
            if (clientId == null || vehicleId == null || assignedDate == null || 
                bookingDate == null || startDate == null || endDate == null || 
                totalCost == null || createdBy == null || paymentType == null) {
                LOGGER.warning("Missing required parameters");
                response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Missing+required+parameters");
                return;
            }

            // Validate adminId
            if (createdBy.trim().isEmpty()) {
                LOGGER.warning("Admin ID is empty");
                response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Admin+ID+is+required");
                return;
            }

            // Create booking object
            Booking booking = new Booking();
            booking.setClientId(clientId);
            booking.setVehicleId(vehicleId);
            booking.setAssignedDate(assignedDate);
            booking.setBookingDate(bookingDate);
            booking.setBookingStartDate(startDate);
            booking.setBookingEndDate(endDate);
            booking.setTotalCost(totalCost);
            booking.setBookingStatus(bookingStatus);
            booking.setCreatedBy(createdBy);

            // Add booking to database
            boolean success = databaseCRUD.addBooking(booking, paymentType);

            if (success) {
                LOGGER.info("Booking created successfully");
                // Get the latest booking ID for this client
                String bookingId = databaseCRUD.getLatestBookingId(clientId);
                response.sendRedirect(request.getContextPath() + "/admin/admin-view-booking.jsp?success=Booking+created+successfully&bookingId=" + bookingId);
            } else {
                LOGGER.warning("Failed to create booking");
                response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Failed+to+create+booking");
            }
        } catch (SQLException | ClassNotFoundException ex) {
            LOGGER.severe("Database error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Database+error:+Please+try+again");
        } catch (NumberFormatException ex) {
            LOGGER.warning("Invalid total cost format: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Invalid+total+cost+format");
        } catch (Exception ex) {
            LOGGER.severe("Unexpected error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Unexpected+error:+Please+try+again");
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
