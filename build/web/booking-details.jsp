<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Booking.Booking"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>

<%
    Logger logger = Logger.getLogger("booking-details.jsp");
    logger.log(Level.INFO, "Starting booking details page");

    String bookingId = request.getParameter("bookingId");
    logger.log(Level.INFO, "Received bookingId: {0}", bookingId);

    if (bookingId == null || bookingId.trim().isEmpty()) {
        logger.log(Level.WARNING, "Invalid bookingId, redirecting to mybooking.jsp");
        response.sendRedirect("mybooking.jsp");
        return;
    }

    UIAccessObject uiAccessObject = new UIAccessObject();
    Booking booking = uiAccessObject.getBookingById(bookingId);
    logger.log(Level.INFO, "Retrieved booking: {0}", booking);

    if (booking == null) {
        logger.log(Level.WARNING, "No booking found for bookingId: {0}, redirecting to mybooking.jsp", bookingId);
        response.sendRedirect("mybooking.jsp");
        return;
    }

    // Fetch related vehicle and payment data
    Vehicle vehicle = null;
    Payment payment = null;
    try {
        vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
        payment = uiAccessObject.getPaymentById(bookingId);
        logger.log(Level.INFO, "Retrieved vehicle: {0}", vehicle);
        logger.log(Level.INFO, "Retrieved payment: {0}", payment);
    } catch (NumberFormatException e) {
        logger.log(Level.SEVERE, "Error parsing vehicleId: {0}", e.getMessage());
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // 2025-05-17 05:37 PM +08
    logger.log(Level.INFO, "Current date time: {0}", currentDateTime);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Booking Details</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .booking-details-section {
                padding: 2rem 0;
                background-color: #f8f9fa;
            }
            .booking-details-container {
                max-width: 960px;
                margin: 2rem auto;
            }
            .booking-details-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                padding: 0 1rem;
            }
            .booking-details-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                margin: 0;
            }
            .back-link {
                font-size: 0.95rem;
                color: #007bff;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .info-card {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 1.5rem;
                margin: 1rem;
            }
            .info-card h3 {
                font-size: 1.25rem;
                font-weight: 600;
                color: #34495e;
                margin-bottom: 1rem;
            }
            .info-card p {
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
                color: #555;
            }
            .info-card strong {
                font-weight: 600;
                color: #34495e;
            }
            .booking-info .total-cost {
                font-size: 1.5rem;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0.5rem;
            }
            .booking-info .status {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            .status-Confirmed {
                background-color: #d4edda;
                color: #155724;
            }
            .status-Pending {
                background-color: #fff3cd;
                color: #85640a;
            }
            .status-Cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-Completed {
                background-color: #cce5ff;
                color: #004085;
            }
            .payment-info .status {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            .payment-info .amount {
                font-size: 1.1rem;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0.3rem;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
                padding: 0 1rem;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="booking-details-section">
            <div class="container">
                <div class="booking-details-container">
                    <div class="booking-details-header">
                        <h2>Booking Details</h2>
                        <a href="mybooking.jsp" class="back-link">Back to Bookings</a>
                    </div>

                    <div class="info-card">
                        <!-- Booking Details -->
                        <div class="booking-info">
                            <h3>Booking Information</h3>
                            <p><strong>Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                            <p><strong>Client ID:</strong> <%= booking.getClientId() != null ? booking.getClientId() : "N/A"%></p>
                            <p><strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                            <p><strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                            <p><strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                            <p><strong>Actual Return Date:</strong> <%= booking.getActualReturnDate() != null ? booking.getActualReturnDate() : "N/A"%></p>
                            <p><strong>Assigned Date:</strong> <%= booking.getAssignedDate() != null ? booking.getAssignedDate() : "N/A"%></p>
                            <p><strong>Total Cost:</strong> RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                            <p><strong>Status:</strong> <span class="status status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>"><%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%></span></p>
                            <p><strong>Created By:</strong> <%= booking.getCreatedBy() != null ? booking.getCreatedBy() : "N/A"%></p>
                        </div>

                        <!-- Vehicle Details -->
                        <div class="vehicle-info">
                            <h3>Vehicle Information</h3>
                            <% if (vehicle != null) {%>
                            <p><strong>Vehicle ID:</strong> <%= booking.getVehicleId() != null ? booking.getVehicleId() : "N/A"%></p>
                            <p><strong>Brand:</strong> <%= vehicle.getVehicleBrand() != null ? vehicle.getVehicleBrand() : "N/A"%></p>
                            <p><strong>Model:</strong> <%= vehicle.getVehicleModel() != null ? vehicle.getVehicleModel() : "N/A"%></p>
                            <% } else { %>
                            <p>No vehicle information available.</p>
                            <% } %>
                        </div>

                        <!-- Related Payments -->
                        <div class="payment-info">
                            <h3>Payment Information</h3>
                            <% if (payment != null) { %>
                            <p><strong>Payment ID:</strong> <%= payment.getPaymentID() %></p>
                            <p><strong>Amount:</strong> RM <%= String.format("%.2f", payment.getAmount()) %></p>
                            <p><strong>Payment Type:</strong> <%= payment.getPaymentType() %></p>
                            <p><strong>Payment Status:</strong> <span class="status status-<%= payment.getPaymentStatus().replace(" ", "") %>"><%= payment.getPaymentStatus() %></span></p>
                            <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() %></p>
                            <% } else { %>
                            <p>No payment information available.</p>
                            <% } %>
                        </div>
                    </div>

                    <div class="timestamp">Last updated: <%= currentDateTime%></div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>
    </body>
</html>