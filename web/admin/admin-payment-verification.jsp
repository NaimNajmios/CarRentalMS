    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ page import="java.util.List"%>
    <%@ page import="java.util.ArrayList"%>
    <%@ page import="Database.UIAccessObject"%>
    <%@ page import="Payment.Payment"%>
    <%@ page import="java.text.SimpleDateFormat"%>
    <%@ page import="java.util.Date"%>
    <%@ page import="java.text.DecimalFormat"%>

    <%
        UIAccessObject uiAccessObject = new UIAccessObject();
        List<Payment> allPayments = uiAccessObject.getAllPaymentDetails();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
        String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());
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
                    padding-top: 56px; /* Account for fixed header height */
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
                    width: 250px; /* Adjust as needed */
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
                    padding: 2rem; /* Adjust padding as needed */
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
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    transition: transform 0.1s ease-in-out;
                }

                .payment-item:hover {
                    transform: scale(1.02);
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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

                .verify-btn:hover {
                    background-color: #218838;
                }

                .reject-btn:hover {
                    background-color: #c82333;
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
                        padding-top: 69px; /* Adjust for smaller screen header */
                    }
                    .wrapper {
                        flex-direction: column; /* Stack sidebar and content on smaller screens */
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
                <nav class="sidebar">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="admin-dashboard.jsp">
                                <i class="fa fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin-users.jsp">
                                <i class="fa fa-users"></i> User Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin-vehicles.jsp">
                                <i class="fa fa-car"></i> Vehicle Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin-bookings.jsp">
                                <i class="fa fa-calendar-check"></i> Booking Management
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="admin-payment-verification.jsp">
                                <i class="fa fa-credit-card"></i> Payment Verification
                            </a>
                        </li>
                    </ul>
                </nav>

                <div class="main-content">
                    <div class="dashboard-header">
                        <h2>Payment Verification</h2>
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Search payments..." class="form-control">
                        </div>
                    </div>

                    <div class="filter-buttons">
                        <button class="filter-btn active" data-status="Pending">Pending</button>
                        <button class="filter-btn" data-status="Completed">Completed</button>
                        <button class="filter-btn" data-status="Cancelled">Cancelled</button>
                        <button class="filter-btn" data-status="all">All</button>
                    </div>

                    <% if (allPayments == null || allPayments.isEmpty()) { %>
                    <div class="no-payments">No payment records found.</div>
                    <% } else { %>
                    <ul class="payment-cards-list" id="paymentCardsList">
                        <% for (Payment payment : allPayments) {%>
                        <li class="payment-item payment-card" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>">
                            <div class="payment-details">
                                <p><strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                                <p><strong>Booking ID:</strong> <%= payment.getBookingID()%></p>
                                <p><strong>Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                            </div>
                            <div class="payment-info">
                                <p class="amount">RM <%= String.format("%.2f", payment.getAmount())%></p>
                                <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>">
                                    <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                </span>
                                <div class="action-buttons">
                                    <% if ("Pending".equals(payment.getPaymentStatus())) { %>
                                    <button class="action-btn verify-btn" onclick="confirmAction('verify', '<%= payment.getPaymentID()%>')">Verify</button>
                                    <button class="action-btn reject-btn" onclick="confirmAction('reject', '<%= payment.getPaymentID()%>')">Reject</button>
                                    <% } else { %>
                                    <button class="action-btn verify-btn" disabled>Verified</button>
                                    <% } %>
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

                    // Function to filter cards by status
                    function filterCards(status) {
                        paymentCards.forEach(card => {
                            const cardStatus = card.getAttribute('data-status');
                            if (status === 'all' || cardStatus === status) {
                                card.classList.remove('hidden');
                            } else {
                                card.classList.add('hidden');
                            }
                        });
                    }

                    // Function to search cards
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

                    // Filter button click handlers
                    filterButtons.forEach(button => {
                        button.addEventListener('click', function () {
                            const status = this.getAttribute('data-status');
                            filterButtons.forEach(btn => btn.classList.remove('active'));
                            this.classList.add('active');
                            filterCards(status);
                        });
                    });

                    // Search input handler
                    searchInput.addEventListener('keyup', function () {
                        const searchText = this.value;
                        searchCards(searchText);
                    });

                    // Initial load: show only pending
                    filterCards('Pending');
                });

                // Confirmation for Verify/Reject actions
                function confirmAction(action, paymentId) {
                    const message = action === 'verify'
                            ? `Are you sure you want to verify payment ${paymentId}?`
                            : `Are you sure you want to reject payment ${paymentId}?`;
                    if (confirm(message)) {
                        // Placeholder for actual action (e.g., form submission or AJAX call)
                        alert(`${action.charAt(0).toUpperCase() + action.slice(1)}ed payment ${paymentId}`);
                    }
                }
            </script>
        </body>
    </html>