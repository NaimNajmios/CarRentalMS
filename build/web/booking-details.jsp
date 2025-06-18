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
    Booking booking = uiAccessObject.getBookingByBookingId(bookingId);
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
        payment = uiAccessObject.getPaymentByBookingId(bookingId);
        logger.log(Level.INFO, "Retrieved vehicle: {0}", vehicle);
        logger.log(Level.INFO, "Retrieved payment: {0}", payment);
    } catch (NumberFormatException e) {
        logger.log(Level.SEVERE, "Error parsing vehicleId: {0}", e.getMessage());
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());
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
            body {
                background-color: #f4f4f4;
                font-family: 'Arial', sans-serif;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                margin: 0;
            }
            .booking-details-container {
                max-width: 960px;
                margin: 2rem auto;
                padding: 2rem;
                background-color: #ffffff;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 8px;
                display: grid;
                grid-template-columns: 1fr 1fr; /* Two main columns */
                gap: 2rem;
            }
            .booking-header {
                grid-column: 1 / -1; /* Span across both columns */
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid #e0e0e0;
            }
            .booking-header h2 {
                font-size: 2rem;
                color: #333;
                margin: 0;
            }
            .back-link {
                text-decoration: none;
                color: #007bff;
                font-weight: bold;
            }
            .detail-section {
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .detail-section h3 {
                font-size: 1.4rem;
                color: #333;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 1px solid #e0e0e0;
            }
            .detail-section p {
                margin-bottom: 0.8rem;
                font-size: 1rem;
                color: #555;
            }
            .detail-section strong {
                color: #333;
            }
            .status-badge {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: bold;
            }
            .status-Confirmed {
                background-color: #d4edda;
                color: #155724;
            }
            .status-Pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-Cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-Completed {
                background-color: #cce5ff;
                color: #004085;
            }
            .vehicle-info-card {
                display: flex;
                gap: 1rem;
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                align-items: flex-start;
            }
            .vehicle-image-container {
                max-width: 180px;
                border-radius: 4px;
                overflow: hidden;
                flex-shrink: 0;
            }
            .vehicle-image {
                display: block;
                width: 100%;
                height: auto;
            }
            .vehicle-details {
                flex-grow: 1;
            }
            .vehicle-details h3 {
                font-size: 1.4rem;
                color: #333;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 1px solid #e0e0e0;
            }
            .vehicle-details-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 0.8rem 1.5rem;
            }
            .vehicle-details-grid p {
                margin-bottom: 0;
                font-size: 0.95rem;
                color: #555;
            }
            .vehicle-details-grid strong {
                color: #333;
            }
            .payment-info-card {
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .proceed-button-container {
                grid-column: 1 / -1;
                text-align: center;
                margin-top: 2rem;
            }
            .proceed-button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1.1rem;
                font-weight: bold;
                text-decoration: none;
            }
            .proceed-button:hover {
                background-color: #218838;
            }
            .cancel-button {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1.1rem;
                font-weight: bold;
                text-decoration: none;
                margin-left: 1rem; /* Space between buttons */
            }
            .cancel-button:hover {
                background-color: #c82333;
            }
            .invoice-button {
                background-color: #17a2b8;
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1.1rem;
                font-weight: bold;
                text-decoration: none;
                margin-left: 1rem;
            }
            .invoice-button:hover {
                background-color: #138496;
            }
            .timestamp {
                grid-column: 1 / -1;
                text-align: right;
                font-size: 0.9rem;
                color: #777;
                margin-top: 2rem;
            }
            .no-info {
                color: #777;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <div class="booking-details-container">
            <div class="booking-header">
                <h2><i class="fas fa-calendar-check"></i> Booking Details</h2>
                <a href="mybooking.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Bookings</a>
            </div>

            <div class="detail-section">
                <h3><i class="fas fa-info-circle"></i> Booking Information</h3>
                <p><strong><i class="fas fa-hashtag"></i> Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                <p><strong><i class="fas fa-user"></i> Client ID:</strong> <%= booking.getClientId() != null ? booking.getClientId() : "N/A"%></p>
                <p><strong><i class="fas fa-calendar"></i> Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                <p><strong><i class="fas fa-calendar-plus"></i> Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                <p><strong><i class="fas fa-calendar-minus"></i> End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                <p><strong><i class="fas fa-clock"></i> Duration:</strong>
                    <%
                        if (booking.getBookingStartDate() != null && booking.getBookingEndDate() != null) {
                            try {
                                Date startDate = sdf.parse(booking.getBookingStartDate());
                                Date endDate = sdf.parse(booking.getBookingEndDate());
                                long diff = endDate.getTime() - startDate.getTime();
                                long days = diff / (24 * 60 * 60 * 1000) + 1; // Add 1 to include both start and end dates
                                out.print(days + (days == 1 ? " day" : " days"));
                            } catch (Exception e) {
                                out.print("N/A");
                            }
                        } else {
                            out.print("N/A");
                        }
                    %>
                </p>
                <p><strong><i class="fas fa-info-circle"></i> Status:</strong> 
                    <span class="status-badge status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>">
                        <% if (booking.getBookingStatus() != null) {%>
                            <% if (booking.getBookingStatus().equals("Pending")) { %>
                                <i class="fas fa-clock"></i>
                            <% } else if (booking.getBookingStatus().equals("Confirmed")) { %>
                                <i class="fas fa-check-circle"></i>
                            <% } else if (booking.getBookingStatus().equals("Completed")) { %>
                                <i class="fas fa-check-double"></i>
                            <% } else if (booking.getBookingStatus().equals("Cancelled")) { %>
                                <i class="fas fa-times-circle"></i>
                            <% } %>
                            <%= booking.getBookingStatus()%>
                        <% } else { %>
                            N/A
                        <% } %>
                    </span>
                </p>
                
                <% if (booking.getBookingStatus() != null && "Completed".equalsIgnoreCase(booking.getBookingStatus().trim())) { %>
                    <p class="text-success mt-3"><i class="fas fa-check-circle"></i> <strong>Your booking is completed! You may now pick up your vehicle.</strong></p>
                <% } %>
            </div>

            <div class="vehicle-info-card">
                <div class="vehicle-image-container">
                    <img src="<%= vehicle != null && vehicle.getVehicleImagePath() != null ? vehicle.getVehicleImagePath() : "images/default-car.jpg"%>" alt="<%= vehicle != null ? vehicle.getVehicleBrand() + " " + vehicle.getVehicleModel() : "No Vehicle Info"%>" class="vehicle-image">
                </div>
                <div class="vehicle-details">
                    <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                    <% if (vehicle != null) {%>
                    <div class="vehicle-details-grid">
                        <p><strong><i class="fas fa-tag"></i> Brand:</strong> <%= vehicle.getVehicleBrand() != null ? vehicle.getVehicleBrand() : "N/A"%></p>
                        <p><strong><i class="fas fa-tag"></i> Model:</strong> <%= vehicle.getVehicleModel() != null ? vehicle.getVehicleModel() : "N/A"%></p>
                        <p><strong><i class="fas fa-cog"></i> Vehicle Type:</strong> <%= vehicle.getVehicleCategory() != null ? vehicle.getVehicleCategory() : "N/A"%></p>
                        <p><strong><i class="fas fa-gas-pump"></i> Fuel Type:</strong> <%= vehicle.getVehicleFuelType() != null ? vehicle.getVehicleFuelType() : "N/A"%></p>
                        <p><strong><i class="fas fa-cogs"></i> Transmission:</strong> <%= vehicle.getTransmissionType() != null ? vehicle.getTransmissionType() : "N/A"%></p>
                        <p><strong><i class="fas fa-id-card"></i> Registration No:</strong> <%= vehicle.getVehicleRegistrationNo() != null ? vehicle.getVehicleRegistrationNo() : "N/A"%></p>
                        <p><strong><i class="fas fa-dollar-sign"></i> Rate Per Day:</strong> RM <%= vehicle.getVehicleRatePerDay() != null ? String.format("%.2f", Double.parseDouble(vehicle.getVehicleRatePerDay())) : "N/A"%></p>
                    </div>
                    <% } else { %>
                    <p class="no-info"><i class="fas fa-exclamation-triangle"></i> No vehicle information available.</p>
                    <% } %>
                </div>
            </div>

            <div class="payment-info-card">
                <h3><i class="fas fa-credit-card"></i> Payment Information</h3>
                <% if (payment != null) {%>
                <p><strong><i class="fas fa-hashtag"></i> Payment ID:</strong> <%= payment.getPaymentID()%></p>
                <p><strong><i class="fas fa-dollar-sign"></i> Amount:</strong> RM <%= String.format("%.2f", payment.getAmount())%></p>
                <p><strong><i class="fas fa-credit-card"></i> Payment Type:</strong> <%= payment.getPaymentType()%></p>
                <p><strong><i class="fas fa-info-circle"></i> Payment Status:</strong> 
                    <span class="status-badge status-<%= payment.getPaymentStatus().replace(" ", "")%>">
                        <% if (payment.getPaymentStatus().equals("Pending")) { %>
                            <i class="fas fa-clock"></i>
                        <% } else if (payment.getPaymentStatus().equals("Completed")) { %>
                            <i class="fas fa-check-circle"></i>
                        <% } else if (payment.getPaymentStatus().equals("Cancelled")) { %>
                            <i class="fas fa-times-circle"></i>
                        <% } %>
                        <%= payment.getPaymentStatus()%>
                    </span>
                </p>
                <% } else if (booking != null && "Pending".equalsIgnoreCase(booking.getBookingStatus())) {%>
                <p><strong><i class="fas fa-dollar-sign"></i> Total Cost:</strong> RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                <p><strong><i class="fas fa-hashtag"></i> Booking ID:</strong> <%= booking.getBookingId()%></p>
                <p><strong><i class="fas fa-hashtag"></i> Payment ID:</strong> Not yet assigned</p>
                <p class="no-info"><i class="fas fa-exclamation-circle"></i> Payment pending. Please proceed to make the payment.</p>
                <% } else { %>
                <p class="no-info"><i class="fas fa-exclamation-triangle"></i> No payment information available.</p>
                <% } %>
            </div>

            <% 
                String bookingStatus = booking.getBookingStatus() != null ? booking.getBookingStatus().trim() : "";
                boolean isPending = "Pending".equalsIgnoreCase(bookingStatus);
                boolean isConfirmed = "Confirmed".equalsIgnoreCase(bookingStatus);
                boolean isCompleted = "Completed".equalsIgnoreCase(bookingStatus);
                boolean isPaymentPending = (payment == null || !"Completed".equalsIgnoreCase(payment.getPaymentStatus()));
                boolean isPaymentCompleted = (payment != null && "Completed".equalsIgnoreCase(payment.getPaymentStatus()));
            %>

            <div class="proceed-button-container">
                <% if (isPending && isPaymentPending) { %>
                    <a href="booking-payment.jsp?bookingId=<%= booking.getBookingId()%>" class="proceed-button"><i class="fas fa-credit-card"></i> Proceed to Payment</a>
                <% } %>
                <a href="client-booking-invoice.jsp?bookingId=<%= booking.getBookingId()%>" target="_blank" class="invoice-button"><i class="fas fa-print"></i> Print Booking Invoice</a>
                <% if (isPending || isConfirmed) { %>
                    <a href="CancelBookingServlet?bookingId=<%= booking.getBookingId()%>&returnPage=booking-details.jsp" 
                       class="cancel-button" 
                       onclick="return confirm('Are you sure you want to cancel this booking? This action cannot be undone.');">
                        <i class="fas fa-times"></i> Cancel Booking
                    </a>
                <% } %>
            </div>

            <div class="timestamp"><i class="fas fa-clock"></i> Last updated: <%= currentDateTime%></div>
        </div>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>
    </body>
</html>