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
<%@ page errorPage="error.jsp" %>

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

    Vehicle vehicle = null;
    Payment payment = null;

    try {
        if (booking.getVehicleId() != null && !booking.getVehicleId().trim().isEmpty()) {
            vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
            logger.log(Level.INFO, "Retrieved vehicle: {0}", vehicle);
        } else {
            logger.log(Level.WARNING, "Vehicle ID is null or empty for bookingId: {0}", bookingId);
        }
        payment = uiAccessObject.getPaymentByBookingId(bookingId);
        logger.log(Level.INFO, "Retrieved payment: {0}", payment);
    } catch (NumberFormatException e) {
        logger.log(Level.SEVERE, "Error parsing vehicleId: {0}", e.getMessage());
        vehicle = null;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    SimpleDateFormat daySdf = new SimpleDateFormat("EEEE");
    String currentDateTime = timeSdf.format(new Date()) + " on " + daySdf.format(new Date()) + ", " + sdf.format(new Date());
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
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
                flex-grow: 1;
            }
            .booking-header {
                grid-column: 1 / -1;
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
            .payment-info-card, .payment-form-card {
                background-color: #f9f9f9;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                margin-top: 2rem;
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
            #cardInfo,
            #bankTransferInfo {
                display: none;
            }
            .bank-transfer-image {
                max-width: 100%;
                height: auto;
                margin-top: 1rem;
            }
            .message {
                grid-column: 1 / -1;
                padding: 1rem;
                border-radius: 4px;
                margin-bottom: 1rem;
                text-align: center;
            }
            .message.success {
                background-color: #d4edda;
                color: #155724;
            }
            .message.error {
                background-color: #f8d7da;
                color: #721c24;
            }
            .alert {
                padding: 1rem;
                margin-bottom: 1rem;
                border: 1px solid transparent;
                border-radius: 0.375rem;
            }
            .alert-info {
                color: #055160;
                background-color: #cff4fc;
                border-color: #b6effb;
            }
            .alert strong {
                color: #055160;
            }
            .text-muted {
                color: #6c757d !important;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <div class="booking-payment-container">
            <%
                String message = request.getParameter("message");
                if (message != null) {
            %>
            <div class="message <%= message.contains("successfully") ? "success" : "error"%>">
                <% if (message.contains("successfully")) { %>
                    <i class="fas fa-check-circle me-2"></i>
                <% } else { %>
                    <i class="fas fa-exclamation-triangle me-2"></i>
                <% } %>
                <%= message%>
            </div>
            <% }%>

            <div class="booking-header">
                <h2><i class="fas fa-credit-card"></i> Booking Payment</h2>
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
                                long days = diff / (24 * 60 * 60 * 1000);
                                out.print(days + (days == 1 ? " day" : " days"));
                            } catch (Exception e) {
                                out.print("N/A");
                                logger.log(Level.WARNING, "Error calculating duration: {0}", e.getMessage());
                            }
                        } else {
                            out.print("N/A");
                        }
                    %>
                </p>
                <p><strong><i class="fas fa-info-circle"></i> Status:</strong> 
                    <span class="status-badge status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>">
                        <% if (booking.getBookingStatus() != null) { %>
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
            </div>

            <div class="vehicle-info-card">
                <div class="vehicle-image-container">
                    <img src="<%= vehicle != null && vehicle.getVehicleImagePath() != null ? vehicle.getVehicleImagePath() : "images/default-car.jpg"%>" alt="<%= vehicle != null ? vehicle.getVehicleBrand() + " " + vehicle.getVehicleModel() : "No Vehicle Info"%>" class="vehicle-image">
                </div>
                <div class="vehicle-details">
                    <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                    <% if (vehicle != null) {%>
                    <p><strong><i class="fas fa-tag"></i> Brand:</strong> <%= vehicle.getVehicleBrand() != null ? vehicle.getVehicleBrand() : "N/A"%></p>
                    <p><strong><i class="fas fa-tag"></i> Model:</strong> <%= vehicle.getVehicleModel() != null ? vehicle.getVehicleModel() : "N/A"%></p>
                    <p><strong><i class="fas fa-cog"></i> Vehicle Type:</strong> <%= vehicle.getVehicleCategory() != null ? vehicle.getVehicleCategory() : "N/A"%></p>
                    <p><strong><i class="fas fa-gas-pump"></i> Fuel Type:</strong> <%= vehicle.getVehicleFuelType() != null ? vehicle.getVehicleFuelType() : "N/A"%></p>
                    <p><strong><i class="fas fa-cogs"></i> Transmission:</strong> <%= vehicle.getTransmissionType() != null ? vehicle.getTransmissionType() : "N/A"%></p>
                    <p><strong><i class="fas fa-id-card"></i> Registration No:</strong> <%= vehicle.getVehicleRegistrationNo() != null ? vehicle.getVehicleRegistrationNo() : "N/A"%></p>
                    <p><strong><i class="fas fa-dollar-sign"></i> Rate Per Day:</strong> RM <%= vehicle.getVehicleRatePerDay() != null ? String.format("%.2f", Double.parseDouble(vehicle.getVehicleRatePerDay())) : "N/A"%></p>
                    <% } else { %>
                    <p class="no-info"><i class="fas fa-exclamation-triangle"></i> No vehicle information available.</p>
                    <% }%>
                </div>
            </div>

            <div class="payment-info-card">
                <h3><i class="fas fa-credit-card"></i> Payment Information</h3>
                <% if (payment != null) {%>
                <p><strong><i class="fas fa-hashtag"></i> Payment ID:</strong> <%= payment.getPaymentID()%></p>
                <p><strong><i class="fas fa-dollar-sign"></i> Amount:</strong> RM <%= String.format("%.2f", payment.getAmount())%></p>
                <p><strong><i class="fas fa-credit-card"></i> Payment Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                <p><strong><i class="fas fa-info-circle"></i> Payment Status:</strong> 
                    <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>">
                        <% if (payment.getPaymentStatus() != null) { %>
                            <% if (payment.getPaymentStatus().equals("Pending")) { %>
                                <i class="fas fa-clock"></i>
                            <% } else if (payment.getPaymentStatus().equals("Completed")) { %>
                                <i class="fas fa-check-circle"></i>
                            <% } else if (payment.getPaymentStatus().equals("Cancelled")) { %>
                                <i class="fas fa-times-circle"></i>
                            <% } %>
                            <%= payment.getPaymentStatus()%>
                        <% } else { %>
                            N/A
                        <% } %>
                    </span>
                </p>
                <p><strong><i class="fas fa-calendar"></i> Payment Date:</strong> <%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A"%></p>
                <% if (payment.getProofOfPayment() != null && !payment.getProofOfPayment().isEmpty()) {%>
                <p><strong><i class="fas fa-file-image"></i> Proof of Payment:</strong> <a href="<%= request.getContextPath()%><%= payment.getProofOfPayment()%>" target="_blank"><i class="fas fa-eye"></i> View</a></p>
                <p class="info"><i class="fas fa-info-circle"></i> Payment proof has been submitted and is awaiting response.</p>
                <% } %>
                <% } else if (booking != null && "Pending".equalsIgnoreCase(booking.getBookingStatus())) {%>
                <p><strong><i class="fas fa-dollar-sign"></i> Total Cost:</strong> RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                <p><strong><i class="fas fa-hashtag"></i> Booking ID:</strong> <%= booking.getBookingId()%></p>
                <p><strong><i class="fas fa-hashtag"></i> Payment ID:</strong> Not yet assigned</p>
                <p class="no-info"><i class="fas fa-exclamation-circle"></i> <strong>Payment pending.</strong> Please provide the payment details in the form below to complete your booking.</p>
                <% } else { %>
                <p class="no-info"><i class="fas fa-exclamation-triangle"></i> No payment information available.</p>
                <% } %>
            </div>

            <% if (booking != null && "Pending".equalsIgnoreCase(booking.getBookingStatus()) && (payment == null || !"Completed".equalsIgnoreCase(payment.getPaymentStatus()))) {%>
            <div class="payment-form-card">
                <h3><i class="fas fa-edit"></i> Payment Form</h3>
                <% if (payment != null && payment.getPaymentType() != null && !payment.getPaymentType().isEmpty()) { %>
                <div class="alert alert-info" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <strong>Payment Already Submitted!</strong><br>
                    Payment type: <strong><%= payment.getPaymentType() %></strong><br>
                    Amount: <strong>RM <%= String.format("%.2f", payment.getAmount()) %></strong><br>
                    Status: <strong><%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "Pending" %></strong><br>
                    <% if (payment.getPaymentDate() != null) { %>
                    Submitted on: <strong><%= payment.getPaymentDate() %></strong>
                    <% } %>
                </div>
                <p class="text-muted"><i class="fas fa-info-circle me-2"></i>Your payment has been submitted and is being processed. You cannot submit another payment for this booking.</p>
                <% } else if (payment != null && payment.getProofOfPayment() != null && !payment.getProofOfPayment().isEmpty()) { %>
                <p class="info"><i class="fas fa-info-circle"></i> Payment proof has been submitted. The form is now disabled.</p>
                <% } else { %>
                <form action="SubmitPayment" method="post" enctype="multipart/form-data" class="payment-form">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId()%>">
                    <input type="hidden" name="paymentId" value="<%= payment != null ? payment.getPaymentID() : ""%>">
                    <label for="paymentType"><i class="fas fa-credit-card"></i> Payment Type:</label>
                    <select id="paymentType" name="paymentType" required onchange="showPaymentDetails()">
                        <option value="">Select payment type</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                        <option value="Cash">Cash</option>
                    </select>
                    <label for="amount"><i class="fas fa-dollar-sign"></i> Amount (RM):</label>
                    <input type="number" id="amount" name="amount" step="0.01" value="<%= booking.getTotalCost() != null ? Double.parseDouble(booking.getTotalCost()) : 0%>" required readonly>

                    <div id="cardInfo" style="display:none;">
                        <label for="cardNumber"><i class="fas fa-credit-card"></i> Card Number:</label>
                        <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456">
                        <label for="cardName"><i class="fas fa-user"></i> Name on Card:</label>
                        <input type="text" id="cardName" name="cardName" placeholder="John Doe">
                        <label for="expiryDate"><i class="fas fa-calendar"></i> Expiry Date:</label>
                        <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY">
                        <label for="cvv"><i class="fas fa-lock"></i> CVV:</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123">
                    </div>

                    <div id="bankTransferInfo" style="display:none;">
                        <p><i class="fas fa-info-circle"></i> Please transfer the amount to the following account:</p>
                        <img src="images/companyUsage/qr_carrentco.png" alt="Bank Transfer Information" class="bank-transfer-image">
                        <label for="proofOfPayment"><i class="fas fa-upload"></i> Upload Proof of Payment (PDF or Image, max 5MB):</label>
                        <input type="file" id="proofOfPayment" name="proofOfPayment" accept="image/*,application/pdf">
                    </div>

                    <p><i class="fas fa-info-circle"></i> <strong>Note:</strong> If selecting Cash, payment will be made upon vehicle pickup.</p>

                    <button type="submit"><i class="fas fa-paper-plane"></i> Submit Payment</button>
                </form>
                <% } %>
            </div>
            <% }%>

            <div class="timestamp"><i class="fas fa-clock"></i> Last updated: <%= currentDateTime%></div>
        </div>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>

        <script>
            function showPaymentDetails() {
                var paymentType = document.getElementById("paymentType").value;
                var cardInfo = document.getElementById("cardInfo");
                var bankTransferInfo = document.getElementById("bankTransferInfo");
                var cardInputs = cardInfo.getElementsByTagName('input');
                var bankTransferInput = document.getElementById("proofOfPayment");

                if (paymentType === "Credit Card" || paymentType === "Debit Card") {
                    cardInfo.style.display = "block";
                    bankTransferInfo.style.display = "none";
                    for (var i = 0; i < cardInputs.length; i++) {
                        cardInputs[i].required = true;
                    }
                    bankTransferInput.required = false;
                } else if (paymentType === "Bank Transfer") {
                    cardInfo.style.display = "none";
                    bankTransferInfo.style.display = "block";
                    for (var i = 0; i < cardInputs.length; i++) {
                        cardInputs[i].required = false;
                    }
                    bankTransferInput.required = true;
                } else {
                    cardInfo.style.display = "none";
                    bankTransferInfo.style.display = "none";
                    for (var i = 0; i < cardInputs.length; i++) {
                        cardInputs[i].required = false;
                    }
                    bankTransferInput.required = false;
                }
            }
        </script>
    </body>
</html>