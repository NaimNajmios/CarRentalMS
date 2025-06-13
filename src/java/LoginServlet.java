import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.*;
import Database.DatabaseConnection;
import User.User;
import User.Client;
import User.Admin;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet implementation class LoginServlet
 * Handles user authentication and login functionality
 */
public class LoginServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    /**
     * Handles POST requests for user login
     * @param request HTTP request containing username and password
     * @param response HTTP response for redirecting after login
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.log(Level.INFO, "Processing login request at {0}", new java.util.Date().toString());
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LOGGER.log(Level.INFO, "Login attempt for username: {0}", username);

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            // Establish database connection
            con = DatabaseConnection.getConnection();
            
            // Query to verify user credentials
            String sql = "SELECT userID, role FROM user WHERE username = ? AND password = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String userID = rs.getString("userID");
                String role = rs.getString("role");

                LOGGER.log(Level.INFO, "User authenticated successfully - userID: {0}, role: {1}", 
                        new Object[]{userID, role});

                // Create new session for authenticated user
                HttpSession session = request.getSession();

                // Create and store User object in session
                User user = new User(userID, username, role);
                session.setAttribute("loggedInUser", user);
                LOGGER.log(Level.INFO, "User object stored in session: {0}", user.toString());

                if ("Administrator".equalsIgnoreCase(role)) {
                    LOGGER.log(Level.INFO, "Processing administrator login for userID: {0}", userID);
                    // Handle administrator login
                    String adminSql = "SELECT adminID, name, email, profileImagePath FROM administrator WHERE userID = ?";
                    PreparedStatement adminStmt = con.prepareStatement(adminSql);
                    adminStmt.setString(1, userID);
                    ResultSet adminRs = adminStmt.executeQuery();
                    
                    if (adminRs.next()) {
                        // Create and store Admin object in session
                        Admin admin = new Admin(userID, adminRs.getString("adminID"), adminRs.getString("name"), adminRs.getString("email"), adminRs.getString("profileImagePath"));
                        session.setAttribute("loggedInAdmin", admin);
                        LOGGER.log(Level.INFO, "Admin object stored in session: {0}", admin.toString());
                        
                        // Verify session attributes after setting
                        User sessionUser = (User) session.getAttribute("loggedInUser");
                        Admin sessionAdmin = (Admin) session.getAttribute("loggedInAdmin");
                        LOGGER.log(Level.INFO, "Session verification - User: {0}, Admin: {1}", 
                                new Object[]{sessionUser != null ? sessionUser.toString() : "null", 
                                           sessionAdmin != null ? sessionAdmin.toString() : "null"});
                        
                        adminRs.close();
                        adminStmt.close();
                        response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp");
                    } else {
                        LOGGER.log(Level.WARNING, "No admin record found for userID: {0}", userID);
                        response.sendRedirect("login.jsp?message=No+administrator+record+found.&type=danger");
                    }
                } else { 
                    LOGGER.log(Level.INFO, "Processing client login for userID: {0}", userID);
                    // Handle client login
                    String clientSql = "SELECT clientID, name, address, phoneNumber, email, profileImagePath FROM client WHERE userID = ?";
                    PreparedStatement clientStmt = con.prepareStatement(clientSql);
                    clientStmt.setString(1, userID);
                    ResultSet clientRs = clientStmt.executeQuery();
                    if (clientRs.next()) {
                        // Create and store Client object in session
                        Client client = new Client(userID, clientRs.getString("clientID"), clientRs.getString("name"), clientRs.getString("address"), clientRs.getString("phoneNumber"), clientRs.getString("email"));
                        client.setProfileImagePath(clientRs.getString("profileImagePath"));
                        session.setAttribute("loggedInClient", client);
                        LOGGER.log(Level.INFO, "Client session created for clientID: {0}", clientRs.getString("clientID"));
                    }
                    clientRs.close();
                    clientStmt.close();
                    response.sendRedirect("client-main.jsp");
                }
            } else {
                LOGGER.log(Level.WARNING, "Failed login attempt for username: {0}", username);
                // Invalid credentials - redirect to login page with error message
                response.sendRedirect("login.jsp?message=Invalid+username+or+password.&type=danger");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during login for user {0}: {1}\nSQL State: {2}\nError Code: {3}", 
                    new Object[]{username, e.getMessage(), e.getSQLState(), e.getErrorCode()});
            // Handle database errors
            response.sendRedirect("login.jsp?message=Database+error+during+login.&type=danger");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during login for user {0}: {1}\nStack trace: {2}", 
                    new Object[]{username, e.getMessage(), e.getStackTrace()});
            // Handle general errors
            response.sendRedirect("login.jsp?message=Login+Error:+" + e.getMessage() + "&type=danger");
        } finally {
            // Clean up database resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing database resources: {0}", ex.getMessage());
            }
        }
    }
}
