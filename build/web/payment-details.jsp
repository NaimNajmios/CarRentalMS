<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="Booking.Booking"%>
<%@page import="Booking.BookingVehicle"%>
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
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // 2025-05-16 10:09 PM +08
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Payment Details</title>
        <%@ include file="include/client-css.html" %>
        <style>
            /* Existing styles remain */
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
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="payment-details-section">

        </section>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>
    </body>
</html>