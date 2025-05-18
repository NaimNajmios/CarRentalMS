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
    Logger logger = Logger.getLogger("booking-payment.jsp");
    logger.log(Level.INFO, "Starting booking payment page");

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
        payment = uiAccessObject.getPaymentById(bookingId); // Check if payment exists
        logger.log(Level.INFO, "Retrieved vehicle: {0}", vehicle);
        logger.log(Level.INFO, "Retrieved payment: {0}", payment);
    } catch (NumberFormatException e) {
        logger.log(Level.SEVERE, "Error parsing vehicleId: {0}", e.getMessage());
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // 10:38 PM +08 on Saturday, May 17, 2025
    logger.log(Level.INFO, "Current date time: {0}", currentDateTime);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Booking Payment</title>
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
            .booking-payment-container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 2rem;
                background-color: #ffffff;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border-radius: 8px;
                display: grid;
                grid-template-columns: 2fr 1fr; /* Two columns, left column twice the width of right */
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
                align-items: center;
            }
            .vehicle-image-container {
                max-width: 180px;
                border-radius: 4px;
                overflow: hidden;
            }
            .vehicle-image {
                display: block;
                width: 100%;
                height: auto;
            }
            .vehicle-details {
                flex-grow: 1;
            }
            .payment-info-card {
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .payment-form {
                margin-top: 1rem;
            }
            .payment-form label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: bold;
                color: #333;
            }
            .payment-form input, .payment-form select {
                width: 100%;
                padding: 0.5rem;
                margin-bottom: 1rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .payment-form input[type="file"] {
                padding: 0.25rem 0;
            }
            .payment-form button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1.1rem;
                font-weight: bold;
            }
            .payment-form button:hover {
                background-color: #218838;
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
            #cardInfo, #bankTransferInfo {
                display: none;
            }
            .bank-transfer-image {
                max-width: 100%;
                height: auto;
                margin-top: 1rem;
            }
            .left-column {
                grid-column: 1 / 2;
            }
            .right-column {
                grid-column: 2 / 3;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <div class="booking-payment-container">
            <div class="booking-header">
                <h2>Booking Payment</h2>
                <a href="mybooking.jsp" class="back-link">← Back to Bookings</a>
            </div>

            <div class="left-column">
                <div class="detail-section">
                    <h3>Booking Information</h3>
                    <p><strong>Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                    <p><strong>Client ID:</strong> <%= booking.getClientId() != null ? booking.getClientId() : "N/A"%></p>
                    <p><strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                    <p><strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                    <p><strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                    <p><strong>Duration:</strong>
                        <%
                            if (booking.getBookingStartDate() != null && booking.getBookingEndDate() != null) {
                                try {
                                    Date startDate = sdf.parse(booking.getBookingStartDate());
                                    Date endDate = sdf.parse(booking.getBookingEndDate());
                                    long diff = endDate.getTime() - startDate.getTime();
                                    long days = diff / (24 * 60 * 60 * 1000);
                                    out.print(days + (days == 1 ? " day" : " days"));
                                } catch (Exception e) {
                                    out.print("N/A");
                                }
                            } else {
                                out.print("N/A");
                            }
                        %>
                    </p>
                    <p><strong>Status:</strong> <span class="status-badge status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>"><%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%></span></p>
                </div>

                <div class="vehicle-info-card">
                    <div class="vehicle-image-container">
                        <img src="<%= vehicle != null && vehicle.getVehicleImagePath() != null ? vehicle.getVehicleImagePath() : "images/default-car.jpg"%>" alt="<%= vehicle != null ? vehicle.getVehicleBrand() + " " + vehicle.getVehicleModel() : "No Vehicle Info"%>" class="vehicle-image">
                    </div>
                    <div class="vehicle-details">
                        <h3>Vehicle Information</h3>
                        <% if (vehicle != null) {%>
                        <p><strong>Brand:</strong> <%= vehicle.getVehicleBrand() != null ? vehicle.getVehicleBrand() : "N/A"%></p>
                        <p><strong>Model:</strong> <%= vehicle.getVehicleModel() != null ? vehicle.getVehicleModel() : "N/A"%></p>
                        <p><strong>Vehicle Type:</strong> <%= vehicle.getVehicleCategory() != null ? vehicle.getVehicleCategory() : "N/A"%></p>
                        <p><strong>Fuel Type:</strong> <%= vehicle.getVehicleFuelType() != null ? vehicle.getVehicleFuelType() : "N/A"%></p>
                        <p><strong>Transmission:</strong> <%= vehicle.getTransmissionType() != null ? vehicle.getTransmissionType() : "N/A"%></p>
                        <p><strong>Registration No:</strong> <%= vehicle.getVehicleRegistrationNo() != null ? vehicle.getVehicleRegistrationNo() : "N/A"%></p>
                        <p><strong>Rate Per Day:</strong> RM <%= vehicle.getVehicleRatePerDay() != null ? String.format("%.2f", Double.parseDouble(vehicle.getVehicleRatePerDay())) : "N/A"%></p>
                        <% } else { %>
                        <p class="no-info">No vehicle information available.</p>
                        <% } %>
                    </div>
                </div>

                <div class="payment-info-card">
                    <h3>Payment Information</h3>
                    <% if (payment != null) {%>
                    <p><strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                    <p><strong>Amount:</strong> RM <%= String.format("%.2f", payment.getAmount())%></p>
                    <p><strong>Payment Type:</strong> <%= payment.getPaymentType()%></p>
                    <p><strong>Payment Status:</strong> <span class="status-badge status-<%= payment.getPaymentStatus().replace(" ", "")%>"><%= payment.getPaymentStatus()%></span></p>
                    <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() != null ? sdf.format(payment.getPaymentDate()) : "N/A"%></p>
                    <% } else if (booking != null && "Pending".equalsIgnoreCase(booking.getBookingStatus())) {%>
                    <p><strong>Total Cost:</strong> RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                    <p><strong>Booking ID:</strong> <%= booking.getBookingId()%></p>
                    <p><strong>Payment ID:</strong> Not yet assigned</p>
                    <p class="no-info">Payment pending. Please provide the payment details in the form on the right.</p>
                    <% } else { %>
                    <p class="no-info">No payment information available.</p>
                    <% } %>
                </div>
            </div>

            <div class="right-column">
                <!-- Payment Input Form -->
                <% if (booking != null && "Pending".equalsIgnoreCase(booking.getBookingStatus()) && (payment == null || !"Completed".equalsIgnoreCase(payment.getPaymentStatus()))) {%>
                <div class="payment-info-card">
                    <h3>Payment Form</h3>
                    <form action="process-payment.jsp" method="post" enctype="multipart/form-data" class="payment-form">
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId()%>">
                        <label for="paymentType">Payment Type:</label>
                        <select id="paymentType" name="paymentType" required onchange="showPaymentDetails()">
                            <option value="">Select payment type</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="Cash">Cash</option>
                        </select>
                        <label for="amount">Amount (RM):</label>
                        <input type="number" id="amount" name="amount" step="0.01" value="<%= booking.getTotalCost() != null ? Double.parseDouble(booking.getTotalCost()) : 0%>" required readonly>
                        
                        <div id="cardInfo" style="display:none;">
                            <label for="cardNumber">Card Number:</label>
                            <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" required>
                            <label for="cardName">Name on Card:</label>
                            <input type="text" id="cardName" name="cardName" placeholder="John Doe" required>
                            <label for="expiryDate">Expiry Date:</label>
                            <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" required>
                            <label for="cvv">CVV:</label>
                            <input type="text" id="cvv" name="cvv" placeholder="123" required>
                        </div>
                        
                        <div id="bankTransferInfo" style="display:none;">
                            <p>Please transfer the amount to the following account:</p>
                            <img src="images/companyUsage/qr_carrentco.png" alt="Bank Transfer Information" class="bank-transfer-image">
                            <label for="proofOfPayment">Upload Proof of Payment (PDF or Image, max 5MB):</label>
                            <input type="file" id="proofOfPayment" name="proofOfPayment" accept="image/*,application/pdf" required>
                        </div>
                        
                        <button type="submit">Submit Payment</button>
                    </form>
                </div>
                <% }%>
            </div>

            <div class="timestamp">Last updated: <%= currentDateTime%></div>
        </div>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>
        
        <script>
            function showPaymentDetails() {
                var paymentType = document.getElementById("paymentType").value;
                var cardInfo = document.getElementById("cardInfo");
                var bankTransferInfo = document.getElementById("bankTransferInfo");
                
                if (paymentType === "Credit Card" || paymentType === "Debit Card") {
                    cardInfo.style.display = "block";
                    bankTransferInfo.style.display = "none";
                } else if (paymentType === "Bank Transfer") {
                    cardInfo.style.display = "none";
                    bankTransferInfo.style.display = "block";
                } else {
                    cardInfo.style.display = "none";
                    bankTransferInfo.style.display = "none";
                }
            }
        </script>
    </body>
</html>