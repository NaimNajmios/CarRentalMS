/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Database.DatabaseCRUD;
import User.User;
import User.Admin;
import User.Client;
import java.io.PrintWriter;

/**
 *
 * @author Naim Najmi
 */
@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChangePasswordServlet.class.getName());

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
            out.println("<title>Servlet ChangePasswordServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePasswordServlet at " + request.getContextPath() + "</h1>");
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
        LOGGER.info("Processing password change request");
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Admin loggedInAdmin = (Admin) session.getAttribute("loggedInAdmin");
        Client loggedInClient = (Client) session.getAttribute("loggedInClient");
        
        // Check if user is logged in
        if (loggedInUser == null) {
            LOGGER.warning("No user logged in");
            session.setAttribute("errorMessage", "Please log in to change your password.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get form data
        String userID = request.getParameter("userID");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (oldPassword == null || newPassword == null || confirmPassword == null || 
            oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            LOGGER.warning("Missing required password fields");
            session.setAttribute("errorMessage", "All password fields are required.");
            redirectToProfile(request, response, loggedInAdmin, loggedInClient);
            return;
        }

        // Check if new password matches confirmation
        if (!newPassword.equals(confirmPassword)) {
            LOGGER.warning("New password and confirmation do not match");
            session.setAttribute("errorMessage", "New password and confirmation do not match.");
            redirectToProfile(request, response, loggedInAdmin, loggedInClient);
            return;
        }

        try {
            // Attempt to change password
            DatabaseCRUD db = new DatabaseCRUD();
            boolean success = db.changePassword(userID, oldPassword, newPassword);

            if (success) {
                LOGGER.info("Password changed successfully for user: " + userID);
                session.setAttribute("successMessage", "Password changed successfully.");
            } else {
                LOGGER.warning("Failed to change password for user: " + userID);
                session.setAttribute("errorMessage", "Current password is incorrect.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error changing password", e);
            session.setAttribute("errorMessage", "An error occurred while changing password.");
        }

        redirectToProfile(request, response, loggedInAdmin, loggedInClient);
    }

    private void redirectToProfile(HttpServletRequest request, HttpServletResponse response, Admin loggedInAdmin, Client loggedInClient) throws IOException {
        if (loggedInAdmin != null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-profile.jsp");
        } else if (loggedInClient != null) {
            response.sendRedirect(request.getContextPath() + "/client-profile.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
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
