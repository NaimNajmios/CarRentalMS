package Servlet;

import Database.DatabaseConnection;
import Database.UIAccessObject;
import Booking.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet implementation class CancelBookingServlet Handles cancellation of a
 * booking by a client.
 */

public class CancelBookingServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CancelBookingServlet.class.getName());
    private static final String LOG_PREFIX = "[CancelBookingServlet] ";

    /**
     * Handles the HTTP <code>GET</code> method. Processes the cancellation
     * request.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, LOG_PREFIX + "Received cancellation request at {0}", new java.util.Date().toString());

        String bookingId = request.getParameter("bookingId");
        String returnPage = request.getParameter("returnPage");

        if (bookingId == null || bookingId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, LOG_PREFIX + "Invalid bookingId received for cancellation. Redirecting to mybooking.jsp.");
            response.sendRedirect(request.getContextPath() + "/mybooking.jsp?message=Invalid+booking+ID+for+cancellation.&type=danger");
            return;
        }

        if (returnPage == null || returnPage.trim().isEmpty()) {
            LOGGER.log(Level.INFO, LOG_PREFIX + "No return page specified, defaulting to mybooking.jsp");
            returnPage = "mybooking.jsp"; // Default return page
        }

        UIAccessObject uiAccessObject = new UIAccessObject();
        Connection con = null;
        PreparedStatement ps = null;
        String message = "";
        String messageType = "danger"; // Default to danger

        try {
            LOGGER.log(Level.INFO, LOG_PREFIX + "Attempting to retrieve booking with ID: {0}", bookingId);
            Booking booking = uiAccessObject.getBookingByBookingId(bookingId);

            if (booking == null) {
                LOGGER.log(Level.WARNING, LOG_PREFIX + "Booking with ID {0} not found.", bookingId);
                message = "Booking not found.";
            } else {
                String currentStatus = booking.getBookingStatus() != null ? booking.getBookingStatus().trim() : "";
                LOGGER.log(Level.INFO, LOG_PREFIX + "Current booking status: {0}", currentStatus);

                if ("Pending".equalsIgnoreCase(currentStatus) || "Confirmed".equalsIgnoreCase(currentStatus)) {
                    LOGGER.log(Level.INFO, LOG_PREFIX + "Proceeding with cancellation for booking ID: {0}", bookingId);
                    con = DatabaseConnection.getConnection();
                    String updateBookingQuery = "UPDATE booking SET bookingStatus = ? WHERE bookingID = ?";
                    ps = con.prepareStatement(updateBookingQuery);
                    ps.setString(1, "Cancelled");
                    ps.setString(2, bookingId);

                    int bookingUpdateStatus = ps.executeUpdate();

                    if (bookingUpdateStatus > 0) {
                        LOGGER.log(Level.INFO, LOG_PREFIX + "Successfully updated booking status to Cancelled");
                        String updatePaymentQuery = "UPDATE payment SET paymentStatus = ? WHERE bookingID = ?";
                        try (PreparedStatement psPayment = con.prepareStatement(updatePaymentQuery)) {
                            psPayment.setString(1, "Refund Initiated");
                            psPayment.setString(2, bookingId);
                            int paymentUpdateStatus = psPayment.executeUpdate();
                            if (paymentUpdateStatus > 0) {
                                LOGGER.log(Level.INFO, LOG_PREFIX + "Booking {0} cancelled and payment status updated successfully.", bookingId);
                                message = "Booking cancelled successfully and payment refund initiated.";
                                messageType = "success";
                            } else {
                                LOGGER.log(Level.WARNING, LOG_PREFIX + "Booking {0} cancelled, but failed to update payment status.", bookingId);
                                message = "Booking cancelled successfully, but payment update failed. Please contact support.";
                                messageType = "warning";
                            }
                        }
                    } else {
                        LOGGER.log(Level.WARNING, LOG_PREFIX + "Failed to cancel booking {0}.", bookingId);
                        message = "Failed to cancel booking. Please try again.";
                    }
                } else if ("Completed".equalsIgnoreCase(currentStatus)) {
                    LOGGER.log(Level.WARNING, LOG_PREFIX + "Attempt to cancel a completed booking {0}.", bookingId);
                    message = "Cannot cancel a completed booking.";
                } else if ("Cancelled".equalsIgnoreCase(currentStatus)) {
                    LOGGER.log(Level.WARNING, LOG_PREFIX + "Attempt to cancel an already cancelled booking {0}.", bookingId);
                    message = "Booking is already cancelled.";
                } else {
                    LOGGER.log(Level.WARNING, LOG_PREFIX + "Cannot cancel booking {0} with status: {1}.", new Object[]{bookingId, currentStatus});
                    message = "Cannot cancel booking with current status: " + currentStatus + ".";
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, LOG_PREFIX + "Database error during booking cancellation for ID {0}: {1}", new Object[]{bookingId, e.getMessage()});
            message = "Database error during cancellation.";
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, LOG_PREFIX + "Unexpected error during booking cancellation for ID {0}: {1}", new Object[]{bookingId, e.getMessage()});
            message = "An unexpected error occurred during cancellation.";
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
                LOGGER.log(Level.INFO, LOG_PREFIX + "Database resources closed successfully");
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, LOG_PREFIX + "Error closing database resources after booking cancellation: {0}", ex.getMessage());
            }
        }

        LOGGER.log(Level.INFO, LOG_PREFIX + "Redirecting to {0} with message: {1}", new Object[]{returnPage, message});
        response.sendRedirect(request.getContextPath() + "/" + returnPage + "?message=" + java.net.URLEncoder.encode(message, "UTF-8") + "&type=" + messageType);
    }

    /**
     * Handles the HTTP <code>POST</code> method. Not supported for
     * cancellation.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, LOG_PREFIX + "Received POST request, forwarding to doGet");
        doGet(request, response); // POST requests are handled by doGet for simplicity
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles cancellation of a booking";
    }
}
