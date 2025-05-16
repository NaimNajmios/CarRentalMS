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

    // Temporary client ID for testing
    clientId = "2000";

    if (clientId == null || clientId.trim().isEmpty()) {
        response.sendRedirect("login.jsp"); // Redirect to login if no client ID
        return;
    }

    UIAccessObject uiAccessObject = new UIAccessObject();
    List<Payment> allPayments = uiAccessObject.getPaymentDetailsByClientID(clientId);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // e.g., 2025-05-16 06:15 PM +08
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Client Payment History</title>
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
            .filter-buttons {
                margin-bottom: 1rem;
            }
            .filter-buttons button {
                padding: 0.5rem 1rem;
                margin-right: 0.5rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
                background-color: #f8f9fa;
                color: #333;
            }
            .filter-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
            .payment-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 1.5rem;
            }
            .payment-table th,
            .payment-table td {
                padding: 1rem;
                text-align: left;
                border-bottom: 1px solid #dee2e6;
            }
            .payment-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #34495e;
            }
            .payment-table th:nth-child(1),
            .payment-table td:nth-child(1) { /* Payment ID */
                width: 10%;
            }
            .payment-table th:nth-child(2),
            .payment-table td:nth-child(2) { /* Booking ID */
                width: 10%;
            }
            .payment-table th:nth-child(3),
            .payment-table td:nth-child(3) { /* Payment Type */
                width: 15%;
            }
            .payment-table th:nth-child(4),
            .payment-table td:nth-child(4) { /* Amount */
                width: 12%;
            }
            .payment-table th:nth-child(5),
            .payment-table td:nth-child(5) { /* Payment Status */
                width: 15%;
            }
            .payment-table th:nth-child(6),
            .payment-table td:nth-child(6) { /* Payment Date */
                width: 15%;
            }
            .payment-table tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            .payment-table tr.clickable-row:hover {
                background-color: #e9ecef;
                cursor: pointer;
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
            .hidden {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="payment-section">
            <div class="container">
                <div class="payment-container">
                    <h2>Payment History for Client ID: <%= clientId%></h2>
                    <p class="text-muted">Below is a list of all payments associated with your account. Click on a row to view details.</p>

                    <div class="filter-buttons">
                        <button class="filter-btn active" data-status="all">All</button>
                        <button class="filter-btn" data-status="Pending">Pending</button>
                        <button class="filter-btn" data-status="Completed">Completed</button>
                        <button class="filter-btn" data-status="Cancelled">Cancelled</button>
                    </div>

                    <% if (allPayments == null || allPayments.isEmpty()) { %>
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
                                <th>Payment Date</th>
                            </tr>
                        </thead>
                        <tbody id="paymentTableBody">
                            <% for (Payment payment : allPayments) {%>
                            <tr class="clickable-row payment-row" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>" onclick="window.location = 'payment-details.jsp?paymentId=<%= payment.getPaymentID()%>'">
                                <td><%= payment.getPaymentID()%></td>
                                <td><%= payment.getBookingID()%></td>
                                <td><%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></td>
                                <td><%= String.format("%.2f", payment.getAmount())%></td>
                                <td><%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%></td>
                                <td><%= payment.getPaymentDate()%></td>
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

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const filterButtons = document.querySelectorAll('.filter-btn');
                const paymentRows = document.querySelectorAll('#paymentTableBody .payment-row');

                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const status = this.getAttribute('data-status');

                        // Update active button style
                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');

                        paymentRows.forEach(row => {
                            const rowStatus = row.getAttribute('data-status');
                            if (status === 'all' || rowStatus === status) {
                                row.classList.remove('hidden');
                            } else {
                                row.classList.add('hidden');
                            }
                        });

                        // If no matching rows, you might want to display a "No payments found" message
                        const visibleRows = document.querySelectorAll('#paymentTableBody .payment-row:not(.hidden)');
                        const noPaymentsMessage = document.querySelector('.no-payments');
                        if (visibleRows.length === 0 && allPaymentsExist()) {
                            noPaymentsMessage.style.display = 'block';
                        } else if (allPaymentsExist()) {
                            noPaymentsMessage.style.display = 'none';
                        }
                    });
                });

                function allPaymentsExist() {
                    return document.querySelectorAll('#paymentTableBody .payment-row').length > 0;
                }
            });
        </script>
    </body>
</html>