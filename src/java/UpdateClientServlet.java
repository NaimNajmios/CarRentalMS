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

/**
 *
 * @author Naim Najmi
 */
@WebServlet("/UpdateClientServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 2, // 2MB
        maxRequestSize = 1024 * 1024 * 10) // 10MB
public class UpdateClientServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateClientServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "uploads/profile_pics/"; // Relative path for storage

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
            out.println("<title>Servlet UpdateClientServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateClientServlet at " + request.getContextPath() + "</h1>");
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
        LOGGER.log(Level.INFO, "Processing client update request at {0}", new java.util.Date().toString());

        String userID = request.getParameter("userID");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String currentImagePath = request.getParameter("currentImagePath");

        String profileImagePath = null;
        Part profileImagePart = null;
        try {
            profileImagePart = request.getPart("profileImage");
        } catch (ServletException e) {
            LOGGER.log(Level.WARNING, "Error retrieving profile image part: {0}", e.getMessage());
        }

        if (profileImagePart != null && profileImagePart.getSize() > 0) {
            String originalFileName = profileImagePart.getSubmittedFileName();
            String extension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                extension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }

            String baseUploadPath = getServletContext().getRealPath("/");
            if (baseUploadPath == null) {
                baseUploadPath = System.getProperty("upload.path", System.getProperty("user.home") + "/app/uploads/");
                LOGGER.log(Level.WARNING, "ServletContext.getRealPath() returned null, using fallback path: {0}", baseUploadPath);
            }
            String uploadPath = baseUploadPath + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean dirCreated = uploadDir.mkdirs();
                if (dirCreated) {
                    LOGGER.log(Level.INFO, "Created upload directory: {0}", uploadPath);
                } else {
                    LOGGER.log(Level.SEVERE, "Failed to create upload directory: {0}. Check permissions.", uploadPath);
                    throw new IOException("Unable to create upload directory: " + uploadPath);
                }
            }

            if (!uploadDir.canWrite()) {
                LOGGER.log(Level.SEVERE, "Upload directory is not writable: {0}. Check permissions.", uploadPath);
                throw new IOException("Upload directory is not writable: " + uploadPath);
            }

            String randomFileName;
            File uploadFile;
            do {
                randomFileName = System.currentTimeMillis() + "_" + Math.round(Math.random() * 1000) + extension;
                uploadFile = new File(uploadPath + randomFileName);
            } while (uploadFile.exists());

            profileImagePath = UPLOAD_DIRECTORY + randomFileName;
            try {
                profileImagePart.write(uploadFile.getAbsolutePath());
                LOGGER.log(Level.INFO, "Profile image uploaded successfully to: {0}", uploadFile.getAbsolutePath());
                if (uploadFile.exists()) {
                    LOGGER.log(Level.INFO, "Confirmed: Profile image file exists at: {0}", uploadFile.getAbsolutePath());
                } else {
                    LOGGER.log(Level.SEVERE, "Profile image file does not exist after writing: {0}", uploadFile.getAbsolutePath());
                    profileImagePath = currentImagePath;
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error writing profile image to disk: {0}", e.getMessage());
                profileImagePath = currentImagePath;
            }
        } else {
            LOGGER.log(Level.INFO, "No new profile image uploaded or file is empty. Retaining current image.");
            profileImagePath = currentImagePath;
        }

        // If currentImagePath was empty and no new file was uploaded, set to default
        if (profileImagePath == null || profileImagePath.isEmpty()) {
            profileImagePath = "images/profilepic/default_profile.jpg";
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            String query = "UPDATE client SET name=?, address=?, phoneNumber=?, email=?, profileImagePath=? WHERE userID=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setString(5, profileImagePath);
            ps.setString(6, userID);
            int status = ps.executeUpdate();

            // Determine the original page from which the request originated
            String referer = request.getHeader("Referer");
            boolean isClientProfileUpdate = referer != null && referer.contains("client-profile.jsp");

            if (status > 0) {
                LOGGER.log(Level.INFO, "Client details updated successfully for User ID: {0}", userID);
                if (isClientProfileUpdate) {
                    response.sendRedirect(request.getContextPath() + "/client-profile.jsp?message=Profile+updated+successfully.&type=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/viewClient.jsp?userID=" + userID + "&message=Client+updated+successfully.&type=success");
                }
            } else {
                LOGGER.log(Level.WARNING, "Failed to update client details for User ID: {0}", userID);
                if (isClientProfileUpdate) {
                    response.sendRedirect(request.getContextPath() + "/client-profile.jsp?message=Error+updating+profile+details.&type=danger");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/editClient.jsp?userID=" + userID + "&message=Error+updating+client+details.&type=danger");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database error during client update for User ID: {0}: {1}", new Object[]{userID, e.getMessage()});
            response.sendRedirect(request.getContextPath() + "/admin/editClient.jsp?userID=" + userID + "&message=Error+updating+client:+" + e.getMessage() + "&type=danger");
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
