<%@page import="Booking.BookingVehicle"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="Booking.Booking"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<%
    String paymentId = request.getParameter("paymentId");
    if (paymentId == null || paymentId.trim().isEmpty()) {
        response.sendRedirect("client-payment-details.jsp");
        return;
    }

    UIAccessObject uiAccessObject = new UIAccessObject();
    Payment payment = uiAccessObject.getPaymentById(paymentId);
    if (payment == null) {
        response.sendRedirect("client-payment-details.jsp");
        return;
    }

    // Fetch related booking and booking vehicle data
    Booking booking = uiAccessObject.getBookingById(payment.getBookingID());
    BookingVehicle bookingVehicle = uiAccessObject.getBookingVehicleByBookingId(payment.getBookingID());

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // 2025-05-16 09:03 PM +08
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Payment Details</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .payment-details-section {
                padding: 2rem 0;
                background-color: #f8f9fa;
            }
            .payment-details-container {
                max-width: 960px;
                margin: 2rem auto;
            }
            .payment-details-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                padding: 0 1rem;
            }
            .payment-details-header h2 {
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
            .payment-details-card {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 1.5rem;
                margin: 0 1rem;
            }
            .payment-details-card h3 {
                font-size: 1.25rem;
                font-weight: 600;
                color: #34495e;
                margin-bottom: 1rem;
            }
            .payment-details-card .details-section {
                margin-bottom: 1.5rem;
            }
            .payment-details-card p {
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
                color: #555;
            }
            .payment-details-card strong {
                font-weight: 600;
                color: #34495e;
            }
            .payment-info .amount {
                font-size: 1.5rem;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0.5rem;
            }
            .payment-info .status {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            .status-Completed {
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

        <section class="payment-details-section">
            <div class="container">
                <div class="payment-details-container">
                    <div class="payment-details-header">
                        <h2>Payment Details</h2>
                        <a href="client-payment-details.jsp" class="back-link">Back to Payment History</a>
                    </div>

                    <div class="payment-details-card">
                        <!-- Payment Details -->
                        <div class="details-section">
                            <h3>Payment Information</h3>
                            <p><strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                            <p><strong>Payment Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                            <p><strong>Amount:</strong> RM <%= String.format("%.2f", payment.getAmount())%></p>
                            <p><strong>Status:</strong> <span class="status status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>"><%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%></span></p>
                            <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() != null ? sdf.format(payment.getPaymentDate()) : "N/A"%></p>
                            <p><strong>Reference No:</strong> <%= payment.getReferenceNo() != null ? payment.getReferenceNo() : "N/A"%></p>
                            <p><strong>Invoice Number:</strong> <%= payment.getInvoiceNumber() != null ? payment.getInvoiceNumber() : "N/A"%></p>
                            <p><strong>Proof of Payment:</strong> <%= payment.getProofOfPayment() != null ? payment.getProofOfPayment() : "N/A"%></p>
                        </div>

                        <!-- Booking Details -->
                        <div class="details-section">
                            <h3>Booking Information</h3>
                            <% if (booking != null) {%>
                            <p><strong>Booking ID:</strong> <%= booking.getBookingId()%></p>
                            <p><strong>Client ID:</strong> <%= booking.getClientId()%></p>
                            <p><strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? sdf.format(booking.getBookingDate()) : "N/A"%></p>
                            <p><strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? sdf.format(booking.getBookingStartDate()) : "N/A"%></p>
                            <p><strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? sdf.format(booking.getBookingEndDate()) : "N/A"%></p>
                            <p><strong>Total Cost:</strong> RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                            <p><strong>Booking Status:</strong> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%></p>
                            <% } else { %>
                            <p>No booking information available.</p>
                            <% } %>
                        </div>

                        <!-- Booking Vehicle Details -->
                        <div class="details-section">
                            <h3>Vehicle Information</h3>
                            <% if (bookingVehicle != null) {%>
                            <p><strong>Vehicle ID:</strong> <%= bookingVehicle.getVehicleID()%></p>
                            <p><strong>Assigned Date:</strong> <%= bookingVehicle.getAssignedDate() != null ? sdf.format(bookingVehicle.getAssignedDate()) : "N/A"%></p>
                            <% } else { %>
                            <p>No vehicle information available.</p>
                            <% }%>
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