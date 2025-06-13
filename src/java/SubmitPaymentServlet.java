/*
 * Servlet to handle payment submission with PDF proof for CarRent bookings.
 */

import Database.DatabaseCRUD;
import Database.UIAccessObject;
import Booking.Booking;
import Payment.Payment;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet to handle payment submission with PDF proof for CarRent bookings.
 *
 * @author Naim Najmi
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10) // 10MB
public class SubmitPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SubmitPaymentServlet.class.getName());
    private final DatabaseCRUD databaseCRUD;
    private final UIAccessObject uiAccessObject = new UIAccessObject();
    private static final String UPLOAD_DIRECTORY = "user-upload/payments/"; // Relative path for storage

    public SubmitPaymentServlet() throws SQLException, ClassNotFoundException {
        this.databaseCRUD = new DatabaseCRUD();
        LOGGER.setLevel(Level.ALL); // Set logger to capture all levels
        LOGGER.info("SubmitPaymentServlet initialized");
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws SQLException if a database error occurs
     * @throws ClassNotFoundException if a required class is not found
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, ClassNotFoundException {

        SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a z 'on' EEEE, MMMM dd, yyyy");
        String currentTime = sdf.format(new Date()); // e.g., 10:05 AM +08 on Sunday, May 18, 2025
        LOGGER.log(Level.INFO, "Processing payment submission request at {0}", currentTime);

        // Retrieve parameters from the form
        String bookingId = request.getParameter("bookingId");
        String paymentId = request.getParameter("paymentId");
        String paymentType = request.getParameter("paymentType");
        String amountStr = request.getParameter("amount");

        LOGGER.log(Level.FINE, "Received parameters: bookingId={0}, paymentType={1}, amount={2}",
                new Object[]{bookingId, paymentType, amountStr});

        // Retrieve card details
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");

        // Log card details securely (mask sensitive data)
        LOGGER.log(Level.FINE, "Card details received: cardName={0}, expiryDate={1}",
                new Object[]{cardName, expiryDate});

        // Retrieve proof of payment
        Part proofOfPaymentPart = request.getPart("proofOfPayment");

        LOGGER.log(Level.FINE, "Received payment details - Booking ID: {0}, Payment Type: {1}, Amount: {2}",
                new Object[]{bookingId, paymentType, amountStr});

        String proofOfPaymentPath = null;
        if (proofOfPaymentPart != null && proofOfPaymentPart.getSize() > 0) {
            // Validate file is a PDF
            String contentType = proofOfPaymentPart.getContentType();
            LOGGER.log(Level.FINE, "Proof of payment content type: {0}", contentType);
            if (!"application/pdf".equals(contentType)) {
                LOGGER.log(Level.WARNING, "Invalid file type: {0}, expected PDF", contentType);
                response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Invalid file type. Please upload a PDF.");
                return;
            }

            // Determine upload path
            String baseUploadPath = getServletContext().getRealPath("/");
            LOGGER.log(Level.FINE, "Base upload path: {0}", baseUploadPath);
            if (baseUploadPath == null) {
                baseUploadPath = System.getProperty("upload.path", System.getProperty("user.home") + "/app/uploads/");
                LOGGER.log(Level.WARNING, "ServletContext.getRealPath() returned null, using fallback path: {0}", baseUploadPath);
            }
            String uploadPath = baseUploadPath + UPLOAD_DIRECTORY;
            LOGGER.log(Level.FINE, "Full upload path: {0}", uploadPath);
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean dirCreated = uploadDir.mkdirs();
                LOGGER.log(Level.FINE, "Upload directory created: {0}", dirCreated);
                if (!dirCreated) {
                    LOGGER.log(Level.SEVERE, "Failed to create upload directory: {0}. Check permissions.", uploadPath);
                    throw new IOException("Unable to create upload directory: " + uploadPath);
                }
            }

            if (!uploadDir.canWrite()) {
                LOGGER.log(Level.SEVERE, "Upload directory is not writable: {0}. Check permissions.", uploadPath);
                throw new IOException("Upload directory is not writable: " + uploadPath);
            }

            // Generate unique filename
            String originalFileName = proofOfPaymentPart.getSubmittedFileName();
            String fileName = bookingId + "_" + System.currentTimeMillis() + ".pdf";
            File uploadFile = new File(uploadPath + fileName);
            LOGGER.log(Level.FINE, "Generated file name: {0}", fileName);

            // Save the PDF
            proofOfPaymentPart.write(uploadFile.getAbsolutePath());
            if (uploadFile.exists()) {
                LOGGER.log(Level.INFO, "PDF proof uploaded successfully to: {0}", uploadFile.getAbsolutePath());
                proofOfPaymentPath = "/" + UPLOAD_DIRECTORY + fileName; // Relative path for DB
            } else {
                LOGGER.log(Level.SEVERE, "PDF proof file does not exist after writing: {0}", uploadFile.getAbsolutePath());
                proofOfPaymentPath = null;
            }
        } else if (paymentType != null && paymentType.equals("Bank Transfer")) {
            LOGGER.log(Level.WARNING, "Proof of payment missing for Bank Transfer");
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Missing proof of payment for Bank Transfer.");
            return;
        }

        // Validate required fields
        if (bookingId == null || bookingId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Booking ID is missing");
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Missing booking ID");
            return;
        }

        if (paymentType == null || paymentType.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Payment type is missing");
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Missing payment type");
            return;
        }

        double amount = 0.0;
        try {
            amount = Double.parseDouble(amountStr);
            LOGGER.log(Level.FINE, "Parsed amount: {0}", amount);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid amount format: {0}", amountStr);
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Invalid amount format");
            return;
        }

        // Fetch booking to validate amount
        Booking booking = uiAccessObject.getBookingByBookingId(bookingId);
        if (booking == null) {
            LOGGER.log(Level.WARNING, "Booking not found for bookingId: {0}", bookingId);
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Booking not found");
            return;
        }

        double expectedAmount = Double.parseDouble(booking.getTotalCost());
        LOGGER.log(Level.FINE, "Expected amount: {0}, Received amount: {1}", new Object[]{expectedAmount, amount});
        if (Math.abs(amount - expectedAmount) > 0.01) {
            LOGGER.log(Level.WARNING, "Amount mismatch: expected {0}, received {1}", new Object[]{expectedAmount, amount});
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Amount mismatch");
            return;
        }

        // Validate fields based on payment type
        if (paymentType.equals("Credit Card") || paymentType.equals("Debit Card")) {
            LOGGER.log(Level.FINE, "Validating card details for {0}", paymentType);
            if (cardNumber == null || cardNumber.trim().isEmpty()
                    || cardName == null || cardName.trim().isEmpty()
                    || expiryDate == null || expiryDate.trim().isEmpty()
                    || cvv == null || cvv.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Missing card details for payment type: {0}", paymentType);
                response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Missing card details");
                return;
            }
            if (!cardNumber.matches("\\d{16}") || !cvv.matches("\\d{3}") || !expiryDate.matches("\\d{2}/\\d{2}")) {
                LOGGER.log(Level.WARNING, "Invalid card details format");
                response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Invalid card details format");
                return;
            }
        } else if (paymentType.equals("Bank Transfer") && proofOfPaymentPath == null) {
            LOGGER.log(Level.WARNING, "Proof of payment missing for Bank Transfer");
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Missing proof of payment for Bank Transfer");
            return;
        }

        // Generate payment ID and other fields
        String paymentStatus = paymentType.equals("Bank Transfer") ? "Pending" : 
                             paymentType.equals("Cash") ? "Pending" : "Completed";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String paymentDate = dateFormat.format(new Date());
        String invoiceNumber = "INV-" + bookingId + "-" + System.currentTimeMillis();

        LOGGER.log(Level.FINE, "Generated payment details: paymentId={0}, paymentStatus={1}, paymentDate={2}, invoiceNumber={3}",
                new Object[]{paymentId, paymentStatus, paymentDate, invoiceNumber});

        // Create and populate Payment object
        Payment payment = new Payment();
        payment.setPaymentType(paymentType);
        payment.setAmount(amount);
        payment.setPaymentStatus(paymentStatus);
        payment.setPaymentDate(paymentDate);
        payment.setInvoiceNumber(invoiceNumber);
        payment.setProofOfPayment(proofOfPaymentPath);

        LOGGER.log(Level.INFO, "Submitting payment for Booking ID: {0} with details: {1}", new Object[]{bookingId, payment});

        // Submit payment to database
        try {
            boolean success = databaseCRUD.submitPayment(paymentId, paymentType, paymentStatus, paymentDate, invoiceNumber, proofOfPaymentPath);
            if (success) {
                LOGGER.log(Level.INFO, "Payment submitted successfully for bookingId: {0}", bookingId);
                response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Payment submitted successfully");
            } else {
                LOGGER.log(Level.WARNING, "Payment submission failed for bookingId: {0}", bookingId);
                response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Payment submission failed");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while submitting payment: {0}", e.getMessage());
            response.sendRedirect("booking-payment.jsp?bookingId=" + bookingId + "&message=Database error: " + e.getMessage());
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
        LOGGER.log(Level.FINE, "Handling GET request");
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Exception in doGet", ex);
            response.sendRedirect("booking-payment.jsp?message=Database error: " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "ClassNotFoundException in doGet", ex);
            response.sendRedirect("booking-payment.jsp?message=Class not found error: " + ex.getMessage());
        }
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
        LOGGER.log(Level.FINE, "Handling POST request");
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Exception in doPost", ex);
            response.sendRedirect("booking-payment.jsp?message=Database error: " + ex.getMessage());
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "ClassNotFoundException in doPost", ex);
            response.sendRedirect("booking-payment.jsp?message=Class not found error: " + ex.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles payment submission with PDF proof for CarRent bookings";
    }
}
