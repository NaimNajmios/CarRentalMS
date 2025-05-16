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
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Client Payment History</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .payment-history-section {
                padding: 2rem 0;
                background-color: #f8f9fa;
            }
            .payment-history-container {
                max-width: 960px;
                margin: 2rem auto;
            }
            .payment-history-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                padding: 0 1rem;
            }
            .payment-history-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                margin: 0;
            }
            .filter-buttons {
                margin-bottom: 1rem;
                padding: 0 1rem;
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
            .payment-cards-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
                padding: 0 1rem;
            }
            .payment-card {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 1.5rem;
                cursor: pointer;
                transition: transform 0.1s ease-in-out;
            }
            .payment-card:hover {
                transform: scale(1.02);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }
            .card-header h5 {
                font-size: 1.1rem;
                font-weight: 600;
                color: #34495e;
                margin: 0;
            }
            .card-header .status {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
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
            .card-details p {
                margin-bottom: 0.5rem;
                font-size: 0.95rem;
                color: #555;
            }
            .card-details strong {
                font-weight: 600;
                color: #34495e;
            }
            .card-footer {
                margin-top: 1rem;
                text-align: right;
                font-size: 1rem;
                color: #27ae60;
                font-weight: bold;
            }
            .no-payments {
                text-align: center;
                color: #7f8c8d;
                padding: 2rem;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
                padding: 0 1rem;
            }
            .hidden {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="payment-history-section">
            <div class="container">
                <div class="payment-history-container">
                    <div class="payment-history-header">
                        <h2>Payment History</h2>
                        <p class="text-muted">Client ID: <%= clientId%></p>
                    </div>

                    <div class="filter-buttons">
                        <button class="filter-btn active" data-status="all">All</button>
                        <button class="filter-btn" data-status="Pending">Pending</button>
                        <button class="filter-btn" data-status="Completed">Completed</button>
                        <button class="filter-btn" data-status="Cancelled">Cancelled</button>
                    </div>

                    <% if (allPayments == null || allPayments.isEmpty()) { %>
                    <div class="no-payments">No payment records found for this client.</div>
                    <% } else { %>
                    <div class="payment-cards-grid" id="paymentCardsGrid">
                        <% for (Payment payment : allPayments) {%>
                        <div class="payment-card payment-item" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>" onclick="window.location = 'payment-details.jsp?paymentId=<%= payment.getPaymentID()%>'">
                            <div class="card-header">
                                <h5>Payment ID: <%= payment.getPaymentID()%></h5>
                                <span class="status status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>"><%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%></span>
                            </div>
                            <div class="card-details">
                                <p><strong>Booking ID:</strong> <%= payment.getBookingID()%></p>
                                <p><strong>Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                                <p><strong>Date:</strong> <%= payment.getPaymentDate()%></p>
                            </div>
                            <div class="card-footer">
                                RM <%= String.format("%.2f", payment.getAmount())%>
                            </div>
                        </div>
                        <% } %>
                    </div>
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
                const paymentCards = document.querySelectorAll('#paymentCardsGrid .payment-item');
                const paymentCardsGrid = document.getElementById('paymentCardsGrid');
                const noPaymentsMessage = document.querySelector('.no-payments');

                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const status = this.getAttribute('data-status');

                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');

                        let visibleCardsCount = 0;
                        paymentCards.forEach(card => {
                            const cardStatus = card.getAttribute('data-status');
                            if (status === 'all' || cardStatus === status) {
                                card.classList.remove('hidden');
                                visibleCardsCount++;
                            } else {
                                card.classList.add('hidden');
                            }
                        });

                        if (visibleCardsCount === 0 && allPaymentsExist()) {
                            noPaymentsMessage.style.display = 'block';
                            paymentCardsGrid.style.display = 'none';
                        } else if (allPaymentsExist()) {
                            noPaymentsMessage.style.display = 'none';
                            paymentCardsGrid.style.display = 'grid';
                        } else {
                            paymentCardsGrid.style.display = 'none';
                        }
                    });
                });

                function allPaymentsExist() {
                    return document.querySelectorAll('#paymentCardsGrid .payment-item').length > 0;
                }

                // Initial state: show all
                if (allPaymentsExist()) {
                    noPaymentsMessage.style.display = 'none';
                    paymentCardsGrid.style.display = 'grid';
                } else {
                    paymentCardsGrid.style.display = 'none';
                }
            });
        </script>
    </body>
</html>