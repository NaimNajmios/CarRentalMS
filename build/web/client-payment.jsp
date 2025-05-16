<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>

<%
    String clientId = (String) session.getAttribute("userId");
    if (clientId == null || clientId.trim().isEmpty()) {
        response.sendRedirect("login.jsp"); // Redirect to login if no client ID
        return;
    }

    UIAccessObject uiAccessObject = new UIAccessObject();
    List<Payment> payments = uiAccessObject.getPaymentsByClientId(Integer.parseInt(clientId));

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // e.g., 2025-05-16 05:20 PM +08
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Client Payment Details</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .payment-section {
                padding: 3rem 0;
            }
            .payment-container {
                max-width: 960px;
                margin: 0 auto;
                background: #fff;
                padding: 2rem;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            .payment-container h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 1.5rem;
            }
            .payment-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 1.5rem;
            }
            .payment-table th,
            .payment-table td {
                padding: 0.75rem;
                text-align: left;
                border-bottom: 1px solid #dee2e6;
            }
            .payment-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #34495e;
            }
            .payment-table tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            .payment-table tr:hover {
                background-color: #e9ecef;
            }
            .no-payments {
                text-align: center;
                color: #7f8c8d;
                padding: 1rem;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="payment-section">
            <div class="container">
                <div class="payment-container">
                    <h2>Payment History for Client ID: <%= clientId%></h2>
                    <p class="text-muted">Below is a list of all payments associated with your account.</p>

                    <% if (payments == null || payments.isEmpty()) { %>
                    <div class="no-payments">No payment records found for this client.</div>
                    <% } else { %>
                    <table class="payment-table">
                        <thead>
                            <tr>
                                <th>Payment ID</th>
                                <th>Booking ID</th>
                                <th>Payment Type</th>
                                <th>Amount (RM)</th>
                                <th>Payment Status</th>
                                <th>Reference No</th>
                                <th>Payment Date</th>
                                <th>Invoice Number</th>
                                <th>Handled By</th>
                                <th>Proof of Payment</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Payment payment : payments) {%>
                            <tr>
                                <td><%= payment.getPaymentID()%></td>
                                <td><%= payment.getBookingID()%></td>
                                <td><%= payment.getPaymentType()%></td>
                                <td><%= new DecimalFormat("#0.00").format(payment.getAmount())%></td>
                                <td><%= payment.getPaymentStatus()%></td>
                                <td><%= payment.getReferenceNo() != null ? payment.getReferenceNo() : "N/A"%></td>
                                <td><%= payment.getPaymentDate() != null ? sdf.format(payment.getPaymentDate()) : "N/A"%></td>
                                <td><%= payment.getInvoiceNumber() != null ? payment.getInvoiceNumber() : "N/A"%></td>
                                <td><%= payment.getHandledBy() != 0 ? payment.getHandledBy() : "N/A"%></td>
                                <td><%= payment.getProofOfPayment() != null ? payment.getProofOfPayment() : "N/A"%></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% }%>
                    <div class="timestamp">Last updated: <%= currentDateTime%></div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>

        <%@ include file="include/scripts.html" %>
    </body>
</html>