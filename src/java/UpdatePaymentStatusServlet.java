/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import Database.DatabaseCRUD;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 *
 * @author Naim Najmi
 */
public class UpdatePaymentStatusServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdatePaymentStatusServlet.class.getName());

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

        LOGGER.info("Processing request to update payment status");

        String paymentId = request.getParameter("paymentId");
        String paymentStatus = request.getParameter("paymentStatus");

        LOGGER.log(Level.INFO, "Updating payment status for paymentId: {0} to status: {1}", new Object[]{paymentId, paymentStatus});

        try {
            DatabaseCRUD databaseCRUD = new DatabaseCRUD();
            boolean success = databaseCRUD.updatePaymentStatus(paymentId, paymentStatus);

            if (success) {
                LOGGER.info("Payment status update successful");
                // Update successful, redirect to the same page
                response.sendRedirect(request.getContextPath() + "/admin/admin-payment-verification.jsp?success=true");
            } else {
                LOGGER.warning("Payment status update failed");
                // Update failed, redirect to the same page with an error message
                response.sendRedirect(request.getContextPath() + "/admin/admin-payment-verification.jsp?error=true");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status", e);
            response.sendRedirect(request.getContextPath() + "/admin/admin-payment-verification.jsp?error=true");
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
        LOGGER.info("Handling GET request");
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
        LOGGER.info("Handling POST request");
        processRequest(request, response);
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
