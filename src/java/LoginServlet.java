import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.*;
import Database.DatabaseConnection;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DatabaseConnection.getConnection()) {
            String sql = "SELECT userID, role FROM user WHERE username = ? AND password = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                HttpSession session = request.getSession();
                session.setAttribute("loggedInUsername", username);
                session.setAttribute("loggedInRole", role);
                session.setAttribute("loggedInUserId", rs.getString("userID"));

                if ("Administrator".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin/admin-dashboard.jsp");
                } else {
                    response.sendRedirect("client-main.jsp");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            response.getWriter().println("Login Error: " + e.getMessage());
        }
    }
}
