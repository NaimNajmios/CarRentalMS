import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Database.DatabaseConnection;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 *
 * @author Naim Najmi
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        LOGGER.log(Level.INFO, "Processing registration request at {0}", new java.util.Date().toString());

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");

        LOGGER.log(Level.INFO, "Registration attempt for username: {0}, email: {1}, name: {2}", 
                new Object[]{username, email, name});

        try (Connection con = DatabaseConnection.getConnection()) {
            // Check if username or email already exists
            String checkExistingSql = "SELECT COUNT(*) FROM user u JOIN client c ON u.userID = c.userID WHERE u.username = ? OR c.email = ?";
            PreparedStatement psCheck = con.prepareStatement(checkExistingSql);
            psCheck.setString(1, username);
            psCheck.setString(2, email);
            ResultSet rsCheck = psCheck.executeQuery();
            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                LOGGER.log(Level.WARNING, "Registration failed - Username or email already exists: {0}, email: {1}", 
                        new Object[]{username, email});
                response.sendRedirect(request.getContextPath() + "/register.jsp?message=Username+or+Email+already+exists.");
                return;
            }

            LOGGER.log(Level.INFO, "Creating new user record for username: {0}", username);
            String sqlUser = "INSERT INTO user (username, password, role) VALUES (?, ?, ?)";
            PreparedStatement psUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, username);
            psUser.setString(2, password);
            psUser.setString(3, "Client"); // Hardcoded role for registration
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            int userID = 0;
            if (rs.next()) {
                userID = rs.getInt(1);
                LOGGER.log(Level.INFO, "Generated userID: {0} for username: {1}", 
                        new Object[]{userID, username});
            }

            LOGGER.log(Level.INFO, "Creating client record for userID: {0}", userID);
            String sqlClient = "INSERT INTO client (userID, name, address, phoneNumber, email, isDeleted) VALUES (?, ?, ?, ?, ?, 0)";
            PreparedStatement psClient = con.prepareStatement(sqlClient);
            psClient.setInt(1, userID);
            psClient.setString(2, name);
            psClient.setString(3, address);
            psClient.setString(4, contact);
            psClient.setString(5, email);
            psClient.executeUpdate();

            LOGGER.log(Level.INFO, "Registration successful for user: {0}, userID: {1}, role: Client", 
                    new Object[]{username, userID});
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Registration+successful.+Please+log+in.");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during registration for user {0}: {1}\nSQL State: {2}\nError Code: {3}", 
                    new Object[]{username, e.getMessage(), e.getSQLState(), e.getErrorCode()});
            response.sendRedirect(request.getContextPath() + "/register.jsp?message=Database+error+during+registration:+" + e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during registration for user {0}: {1}\nStack trace: {2}", 
                    new Object[]{username, e.getMessage(), e.getStackTrace()});
            response.sendRedirect(request.getContextPath() + "/register.jsp?message=An+unexpected+error+occurred:+" + e.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles new user registration.";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "GET request received from IP: {0}, redirecting to registration page", 
                request.getRemoteAddr());
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
}

