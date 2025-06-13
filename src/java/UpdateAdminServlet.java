/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Database.DatabaseConnection;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.util.logging.Logger;
import java.util.logging.Level;
import User.Admin;
import User.User;

/**
 *
 * @author Naim Najmi
 */
@WebServlet("/UpdateAdminServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 2, // 2MB
        maxRequestSize = 1024 * 1024 * 10) // 10MB
public class UpdateAdminServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateAdminServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "images/profilepic";

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
            out.println("<title>Servlet UpdateAdminServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAdminServlet at " + request.getContextPath() + "</h1>");
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
        LOGGER.log(Level.INFO, "Processing administrator update request at {0}", new java.util.Date().toString());

        String userID = request.getParameter("userID");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String currentImagePath = request.getParameter("currentImagePath");

        // Get the uploaded file
        Part filePart = request.getPart("profileImage");
        String profileImagePath = currentImagePath;
        
        // Handle file upload if a new image was selected
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
            String uploadPath = getUploadPath(request);
            
            // Create directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Save the file
            filePart.write(uploadPath + File.separator + fileName);
            profileImagePath = UPLOAD_DIRECTORY + "/" + fileName;
            
            // Delete old image if it exists and is not the default
            if (currentImagePath != null && !currentImagePath.isEmpty() && 
                !currentImagePath.equals(UPLOAD_DIRECTORY + "/default_profile.jpg")) {
                File oldFile = new File(request.getServletContext().getRealPath("/") + currentImagePath);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "UPDATE administrator SET name=?, phoneNumber=?, email=?, profileImagePath=? WHERE userID=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, profileImagePath);
            ps.setString(5, userID);
            int status = ps.executeUpdate();

            if (status > 0) {
                LOGGER.log(Level.INFO, "Admin details updated successfully for User ID: {0}", userID);
                
                // Update the session data
                Admin updatedAdmin = (Admin) request.getSession().getAttribute("loggedInAdmin");
                if (updatedAdmin != null) {
                    updatedAdmin.setName(name);
                    updatedAdmin.setPhoneNumber(phone);
                    updatedAdmin.setEmail(email);
                    updatedAdmin.setProfileImagePath(profileImagePath);
                    request.getSession().setAttribute("loggedInAdmin", updatedAdmin);
                }
                
                request.getSession().setAttribute("successMessage", "Profile updated successfully.");
                response.sendRedirect(request.getContextPath() + "/admin/admin-profile.jsp");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update profile.");
                response.sendRedirect(request.getContextPath() + "/admin/admin-profile.jsp");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating admin profile", e);
            request.getSession().setAttribute("errorMessage", "An error occurred while updating your profile.");
            response.sendRedirect(request.getContextPath() + "/admin/admin-profile.jsp");
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private String getUploadPath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/") + UPLOAD_DIRECTORY;
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
