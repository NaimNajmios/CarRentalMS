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
        LOGGER.info("Received booking creation request");

        try {
            // Get the booking details from the request
            String clientId = request.getParameter("clientId");
            String vehicleId = request.getParameter("vehicleId");
            String assignedDate = request.getParameter("assignedDate");
            String bookingDate = request.getParameter("bookingDate");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String totalCost = request.getParameter("totalCost");
            String bookingStatus = "Completed";
            String createdBy = request.getParameter("adminId"); // Get admin ID from request

            // Validate required parameters
            if (clientId == null || vehicleId == null || startDate == null || endDate == null || totalCost == null) {
                LOGGER.warning("Missing required parameters");
                response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Missing+required+parameters");
                return;
            }

            // Create a new booking object
            Booking booking = new Booking(clientId, vehicleId, assignedDate, bookingDate, startDate, endDate, totalCost,
                    bookingStatus, createdBy);

            LOGGER.info("Created booking object: " + booking);

            // Add the booking to the database
            boolean isBookingAdded = databaseCRUD.addBooking(booking);

            if (isBookingAdded) {
                LOGGER.info("Booking added successfully");
                // Get the latest booking ID for this client
                String bookingId = databaseCRUD.getLatestBookingId(clientId);
                response.sendRedirect(request.getContextPath() + "/admin/admin-view-booking.jsp?success=Booking+created+successfully&bookingId=" + bookingId);
            } else {
                LOGGER.warning("Failed to add booking");
                response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Failed+to+create+booking");
            }

        } catch (SQLException | ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "Error creating booking", ex);
            response.sendRedirect(request.getContextPath() + "/admin/admin-create-booking.jsp?error=Database+error:+"
                    + ex.getMessage().replace(" ", "+"));
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
