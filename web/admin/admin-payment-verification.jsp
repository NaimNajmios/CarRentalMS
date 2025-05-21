<%@ page import="Booking.Booking"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>

<%
    Logger logger = Logger.getLogger(this.getClass().getName());

    List<Payment> allPayments = new ArrayList<>();
    String errorMessage = null;
    String successMessage = null;
    String currentDateTime = "";

    try {
        UIAccessObject uiAccessObject = new UIAccessObject();
        allPayments = uiAccessObject.getAllPaymentDetails();

        for (Payment payment : allPayments) {
            Booking booking = uiAccessObject.getBookingById(payment.getBookingID());
            if (booking != null) {
                payment.setBooking(booking);
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
        currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());

        logger.log(Level.INFO, "Retrieved {0} payments", new Object[]{allPayments.size()});

        // Check for success or error messages in URL parameters
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        if ("true".equals(success)) {
            successMessage = "Status updated successfully.";
        } else if (error != null && !error.isEmpty()) {
            errorMessage = "An error occurred: " + error;
        }

    } catch (Exception e) {
        errorMessage = "An error occurred while processing payment data: " + e.getMessage();
        logger.log(Level.SEVERE, "Error in admin-payment-verification.jsp", e);
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Payment Verification</title>
        <%@ include file="../include/admin-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f4f4;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                margin: 0;
                padding-top: 56px;
            }

            header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 1000;
            }

            .wrapper {
                display: flex;
                flex-grow: 1;
            }

            .sidebar {
                width: 250px;
                background-color: #f8f9fa;
                padding: 20px;
                flex-shrink: 0;
            }

            .sidebar .nav-link {
                color: #4b5563;
                padding: 0.75rem 1rem;
                transition: color 0.2s;
                display: block;
                text-decoration: none;
            }

            .sidebar .nav-link:hover {
                color: #2563eb;
                background-color: #e9ecef;
            }

            .sidebar .nav-link i {
                margin-right: 0.75rem;
            }

            .sidebar .nav-item {
                margin-bottom: 0.5rem;
            }

            .main-content {
                flex-grow: 1;
                padding: 2rem;
                background-color: #f4f4f4;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }

            .dashboard-header h2 {
                font-size: 1.75rem;
                color: #333;
                font-weight: 700;
                margin: 0;
            }

            .search-box {
                position: relative;
                max-width: 300px;
            }

            .search-box input {
                padding: 0.6rem 1rem 0.6rem 2.2rem;
                border: 1px solid #ced4da;
                border-radius: 0.375rem;
                width: 100%;
                font-size: 0.9rem;
                transition: border-color 0.2s;
            }

            .search-box input:focus {
                border-color: #007bff;
                outline: none;
            }

            .search-box i {
                position: absolute;
                left: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            .filter-buttons {
                margin-bottom: 1.5rem;
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

            .payment-cards-list {
                list-style: none;
                padding: 0;
            }

            .payment-item {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 1.5rem;
                padding: 1.5rem;
                transition: transform 0.1s ease-in-out;
            }

            .payment-item:hover {
                transform: scale(1.02);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .payment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .payment-details {
                flex-grow: 1;
                margin-right: 1rem;
            }

            .payment-details p {
                margin-bottom: 0.3rem;
                font-size: 0.95rem;
                color: #555;
            }

            .payment-details strong {
                font-weight: 600;
                color: #34495e;
            }

            .payment-info {
                text-align: right;
                min-width: 200px;
            }

            .payment-info .amount {
                font-size: 1.1rem;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0.5rem;
            }

            .status-badge {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .status-Pending {
                background-color: #fff3cd;
                color: #85640a;
            }

            .status-Completed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-Cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }

            .action-buttons {
                margin-top: 0.5rem;
            }

            .action-btn {
                padding: 0.4rem 0.8rem;
                border-radius: 0.25rem;
                font-size: 0.8rem;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.15s ease-in-out;
                margin-left: 0.5rem;
                border: 1px solid transparent;
            }

            .verify-btn {
                background-color: #28a745;
                color: white;
            }

            .reject-btn {
                background-color: #dc3545;
                color: white;
            }

            .cancel-btn {
                background-color: #6c757d;
                color: white;
            }

            .verify-btn:hover {
                background-color: #218838;
            }

            .reject-btn:hover {
                background-color: #c82333;
            }

            .cancel-btn:hover {
                background-color: #5a6268;
            }

            .action-btn:disabled {
                background-color: #adb5bd;
                opacity: 0.6;
                cursor: not-allowed;
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

            @media (max-width: 768px) {
                body {
                    padding-top: 69px;
                }
                .wrapper {
                    flex-direction: column;
                }
                .sidebar {
                    width: 100%;
                    margin-bottom: 1rem;
                    padding: 15px;
                }
                .main-content {
                    padding: 1.5rem;
                }
                .dashboard-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
                .search-box {
                    max-width: 100%;
                }
                .payment-item {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .payment-info {
                    text-align: left;
                    margin-top: 1rem;
                    width: 100%;
                }
                .action-buttons {
                    margin-top: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <header>
            <%@ include file="../include/admin-header.jsp" %>
        </header>

        <div class="wrapper">
            <%@ include file="../include/admin-sidebar.jsp" %>

            <div class="main-content">
                <% if (errorMessage != null) {%>
                <div style="color: #721c24; background-color: #f8d7da; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                    <strong>Error:</strong> <%= errorMessage%>
                </div>
                <% } %>
                <% if (successMessage != null) {%>
                <div style="color: #155724; background-color: #d4edda; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                    <strong>Success:</strong> <%= successMessage%>
                </div>
                <% } %>
                <div class="dashboard-header">
                    <h2>Payment Verification</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search payments..." class="form-control">
                    </div>
                </div>

                <div class="filter-buttons">
                    <button class="filter-btn active" data-status="Pending">Pending</button>
                    <select id="pendingFilter" style="display: none;">
                        <option value="All">All Pending</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                        <option value="Cash">Cash</option>
                    </select>
                    <button class="filter-btn" data-status="Completed">Completed</button>
                    <button class="filter-btn" data-status="Cancelled">Cancelled</button>
                    <button class="filter-btn" data-status="all">All</button>
                </div>

                <% if (allPayments == null || allPayments.isEmpty()) { %>
                <div class="no-payments">No payment records found.</div>
                <% } else { %>
                <ul class="payment-cards-list" id="paymentCardsList">
                    <% for (Payment payment : allPayments) {%>
                    <li class="payment-item payment-card" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>" data-type="<%= payment.getPaymentType() != null ? payment.getPaymentType() : ""%>">
                        <div class="payment-header">
                            <div class="payment-details">
                                <p><strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                                <p><strong>Booking ID:</strong> <%= payment.getBookingID()%></p>
                                <p><strong>Payment Date:</strong> <%= payment.getPaymentDate()%></p>
                                <p><strong>Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                            </div>
                            <div class="payment-info">
                                <p class="amount">RM <%= String.format("%.2f", payment.getAmount())%></p>
                                <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().toLowerCase().replace(" ", "-") : ""%>">
                                    <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                </span>
                                <div class="action-buttons">
                                    <% if ("Pending".equals(payment.getPaymentStatus())) {%>
                                    <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                        <input type="hidden" name="paymentStatus" value="Completed">
                                        <button type="submit" class="action-btn verify-btn" onclick="return confirm('Are you sure you want to verify payment <%= payment.getPaymentID()%>?')">Verify</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                        <input type="hidden" name="paymentStatus" value="Cancelled">
                                        <button type="submit" class="action-btn reject-btn" onclick="return confirm('Are you sure you want to reject payment <%= payment.getPaymentID()%>?')">Reject</button>
                                    </form>
                                    <% if ("Bank Transfer".equals(payment.getPaymentType())) {%>
                                    <button class="action-btn view-proof-btn" onclick="viewProofOfPayment('<%= request.getContextPath()%><%= payment.getProofOfPayment()%>')">View Proof</button>
                                    <% } %>
                                    <% } else if ("Completed".equals(payment.getPaymentStatus())) { %>
                                    <button class="action-btn verify-btn" disabled>Verified</button>
                                    <% } else if ("Cancelled".equals(payment.getPaymentStatus())) { %>
                                    <button class="action-btn cancel-btn" disabled>Cancelled</button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </li>
                    <% } %>
                </ul>
                <% }%>

                <div class="timestamp">Last updated: <%= currentDateTime%></div>
            </div>
        </div>

        <%@ include file="../include/scripts.html" %>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const filterButtons = document.querySelectorAll('.filter-btn');
                const paymentCards = document.querySelectorAll('#paymentCardsList .payment-item');
                const searchInput = document.getElementById('searchInput');
                const pendingFilter = document.getElementById('pendingFilter');

                function filterCards(status, type = 'All') {
                    paymentCards.forEach(card => {
                        const cardStatus = card.getAttribute('data-status');
                        const cardType = card.getAttribute('data-type');
                        if (status === 'all' ||
                                (cardStatus === status && (type === 'All' || cardType === type))) {
                            card.classList.remove('hidden');
                        } else {
                            card.classList.add('hidden');
                        }
                    });
                }

                function searchCards(searchText) {
                    paymentCards.forEach(card => {
                        const text = card.textContent.toLowerCase();
                        if (text.includes(searchText.toLowerCase())) {
                            card.classList.remove('hidden');
                        } else {
                            card.classList.add('hidden');
                        }
                    });
                }

                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const status = this.getAttribute('data-status');
                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');
                        if (status === 'Pending') {
                            pendingFilter.style.display = 'inline-block';
                            filterCards(status, pendingFilter.value);
                        } else {
                            pendingFilter.style.display = 'none';
                            filterCards(status);
                        }
                    });
                });

                pendingFilter.addEventListener('change', function () {
                    filterCards('Pending', this.value);
                });

                searchInput.addEventListener('input', function () {
                    const searchText = this.value;
                    searchCards(searchText);
                });

                filterCards('Pending');
            });

            function viewProofOfPayment(proofUrl) {
                if (proofUrl) {
                    window.open(proofUrl, '_blank');
                } else {
                    alert('No proof of payment available.');
                }
            }
        </script>
    </body>
</html>