/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Vehicles.Vehicles;
import Database.vehicleDAO;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 *
 * @author nadhi
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10) // 10MB
public class ExtendedVehicleUpdateServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditVehicleServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "images/vehicles/"; // Relative path for storage

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditVehicleServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditVehicleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        LOGGER.log(Level.INFO, "Processing vehicle update request at {0}", new java.util.Date().toString());

        Vehicles v = new Vehicles();
        v.setVehicleID(request.getParameter("vehicleID"));
        v.setModel(request.getParameter("model"));
        v.setBrand(request.getParameter("brand"));
        v.setManufacturingYear(Integer.parseInt(request.getParameter("manufacturingYear")));
        v.setAvailability(Boolean.parseBoolean(request.getParameter("availability")));
        v.setCategory(request.getParameter("category"));
        v.setFuelType(request.getParameter("fuelType"));
        v.setTransmissionType(request.getParameter("transmissionType"));
        v.setMileage(Integer.parseInt(request.getParameter("mileage")));
        v.setRatePerDay(Double.parseDouble(request.getParameter("ratePerDay")));
        v.setRegistrationNo(request.getParameter("registrationNo"));

        String vehicleImagePath = null;
        Part vehicleImagePart = null;
        try {
            vehicleImagePart = request.getPart("vehicleImage");
        } catch (ServletException e) {
            LOGGER.log(Level.WARNING, "Error retrieving vehicle image part: {0}", e.getMessage());
        }

        if (vehicleImagePart != null && vehicleImagePart.getSize() > 0) {
            String originalFileName = vehicleImagePart.getSubmittedFileName();
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

            vehicleImagePath = UPLOAD_DIRECTORY + randomFileName;
            try {
                vehicleImagePart.write(uploadFile.getAbsolutePath());
                LOGGER.log(Level.INFO, "Vehicle image uploaded successfully to: {0}", uploadFile.getAbsolutePath());
                if (uploadFile.exists()) {
                    LOGGER.log(Level.INFO, "Confirmed: Vehicle image file exists at: {0}", uploadFile.getAbsolutePath());
                } else {
                    LOGGER.log(Level.SEVERE, "Vehicle image file does not exist after writing: {0}", uploadFile.getAbsolutePath());
                    vehicleImagePath = null;
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error writing vehicle image to disk: {0}", e.getMessage());
                vehicleImagePath = null;
            }
        } else {
            LOGGER.log(Level.INFO, "No new vehicle image uploaded or file is empty.");
            String existingPath = vehicleDAO.getVehicleImagePath(v.getVehicleID());
            if (existingPath != null && !existingPath.isEmpty()) {
                vehicleImagePath = existingPath;
            } else {
                vehicleImagePath = "/images/vehicles/default_vehicle.jpg";
            }
        }

        v.setVehicleImagePath(vehicleImagePath);

        LOGGER.log(Level.INFO, "Updating vehicle ID: {0} with new details and image path: {1}",
                new Object[]{v.getVehicleID(), vehicleImagePath});

        int status = vehicleDAO.update(v);
        if (status > 0) {
            LOGGER.log(Level.INFO, "Vehicle details updated successfully for ID: {0}", v.getVehicleID());
            response.sendRedirect(request.getContextPath() + "/admin/admin-vehicles.jsp?message=Vehicle+updated+successfully&type=success");
        } else {
            LOGGER.log(Level.WARNING, "Failed to update vehicle details for ID: {0}", v.getVehicleID());
            request.setAttribute("error", "Failed to update vehicle.");
            request.getRequestDispatcher("/admin/editVehicle.jsp?id=" + v.getVehicleID()).forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles vehicle update functionality including image upload.";
    }
}