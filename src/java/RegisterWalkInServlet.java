/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Database.DatabaseCRUD;
import java.io.PrintWriter;

/**
 *
 * @author Naim Najmi
 */
public class RegisterWalkInServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterWalkInServlet.class.getName());
    private DatabaseCRUD databaseCRUD;

    public RegisterWalkInServlet() {
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
            out.println("<title>Servlet RegisterWalkInServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterWalkInServlet at " + request.getContextPath() + "</h1>");
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
        response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp");
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
        LOGGER.info("Processing walk-in registration request");

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("full-name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phone-number");

        try {
            // Validate required fields based on role
            if (username == null || password == null || role == null || name == null || 
                email == null || phoneNumber == null) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=All+fields+are+required&type=danger");
                return;
            }

            // Only require address for Client role
            if (role.equals("Client") && address == null) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=Address+is+required+for+clients&type=danger");
                return;
            }

            // Register the user
            boolean success = databaseCRUD.registerWalkInUser(username, password, role, name, email, address, phoneNumber);

            if (success) {
                LOGGER.info("Successfully registered new " + role + " user: " + username);
                response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=User+registered+successfully&type=success");
            } else {
                LOGGER.warning("Failed to register user - Username or email already exists: " + username);
                response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=Username+or+email+already+exists&type=danger");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during walk-in registration", e);
            response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=Database+error:+Please+try+again&type=danger");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during walk-in registration", e);
            response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp?message=An+unexpected+error+occurred&type=danger");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles walk-in user registration by administrators";
    }// </editor-fold>

}
