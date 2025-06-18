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
<%@ page import="User.Admin"%>

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
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 0.5rem;
            }

            .filter-buttons button {
                padding: 0.5rem 1rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
                background-color: #f8f9fa;
                color: #333;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .filter-buttons button .count {
                background-color: rgba(0, 0, 0, 0.1);
                padding: 0.1rem 0.4rem;
                border-radius: 10px;
                font-size: 0.8rem;
            }

            .filter-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .filter-buttons button.active .count {
                background-color: rgba(255, 255, 255, 0.2);
            }

            .filter-buttons select {
                padding: 0.5rem 2rem 0.5rem 1rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                background-color: #f8f9fa;
                color: #333;
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 0.5rem center;
                background-size: 1em;
                transition: all 0.2s ease;
                font-size: 0.9rem;
                font-weight: 500;
                min-width: 140px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .filter-buttons select:hover {
                border-color: #007bff;
                background-color: #fff;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
                transform: translateY(-1px);
            }

            .filter-buttons select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
                background-color: #fff;
            }

            .filter-buttons select.active {
                border-color: #007bff;
                background-color: #e3f2fd;
                color: #007bff;
                font-weight: 600;
            }

            .filter-buttons select option {
                padding: 0.75rem;
                font-weight: 500;
                background-color: #fff;
                color: #333;
            }

            .filter-buttons select option:hover {
                background-color: #f8f9fa;
            }

            .filter-buttons select option[value="All"] {
                color: #007bff;
                font-weight: 600;
            }

            .filter-buttons select option[value="Bank Transfer"] {
                color: #28a745;
            }

            .filter-buttons select option[value="Cash"] {
                color: #ffc107;
            }

            .pending-filter-container {
                display: none;
                align-items: center;
                gap: 0.5rem;
                margin-left: 0.5rem;
                padding: 0.25rem;
                background-color: #fff3cd;
                border-radius: 6px;
                border: 1px solid #ffeaa7;
                animation: slideIn 0.3s ease-out;
            }

            .pending-filter-container.show {
                display: flex;
            }

            .pending-filter-label {
                font-size: 0.8rem;
                font-weight: 600;
                color: #856404;
                white-space: nowrap;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
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

            .payment-details:hover {
                background-color: #f8f9fa;
                border-radius: 4px;
                padding: 0.5rem;
                margin: -0.5rem;
                transition: background-color 0.2s ease;
            }

            .payment-info > div:first-child:hover {
                background-color: #f8f9fa;
                border-radius: 4px;
                padding: 0.5rem;
                margin: -0.5rem;
                transition: background-color 0.2s ease;
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

            .action-btn:hover {
                transform: none;
            }

            .action-btn:active {
                transform: scale(0.98);
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
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Error:</strong> <%= errorMessage%>
                </div>
                <% } %>
                <% if (successMessage != null) {%>
                <div style="color: #155724; background-color: #d4edda; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                    <i class="fas fa-check-circle me-2"></i>
                    <strong>Success:</strong> <%= successMessage%>
                </div>
                <% } %>
                <div class="dashboard-header">
                    <h2><i class="fas fa-credit-card"></i> Payment Verification</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search payments..." class="form-control">
                    </div>
                </div>

                <div class="filter-buttons">
                    <button class="filter-btn active" data-status="Pending"><i class="fas fa-clock"></i> Pending <span class="count" id="pendingCount">0</span></button>
                    <div class="pending-filter-container">
                        <select id="pendingFilter" style="display: none;" class="form-select">
                            <option value="All">All Pending</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="Cash">Cash</option>
                        </select>
                        <span class="pending-filter-label">Filter</span>
                    </div>
                    <button class="filter-btn" data-status="Confirmed"><i class="fas fa-check-circle"></i> Confirmed <span class="count" id="confirmedCount">0</span></button>
                    <button class="filter-btn" data-status="Completed"><i class="fas fa-check-double"></i> Completed <span class="count" id="completedCount">0</span></button>
                    <button class="filter-btn" data-status="Cancelled"><i class="fas fa-times-circle"></i> Cancelled <span class="count" id="cancelledCount">0</span></button>
                    <button class="filter-btn" data-status="all"><i class="fas fa-list"></i> All <span class="count" id="allCount">0</span></button>
                </div>

                <% if (allPayments == null || allPayments.isEmpty()) { %>
                <div class="no-payments"><i class="fas fa-inbox"></i> No payment records found.</div>
                <% } else { %>
                <ul class="payment-cards-list" id="paymentCardsList">
                    <% for (Payment payment : allPayments) {%>
                    <li class="payment-item payment-card" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>" data-type="<%= payment.getPaymentType() != null ? payment.getPaymentType() : ""%>">
                        <div class="payment-header">
                            <div class="payment-details" onclick="window.location.href='admin-view-booking.jsp?bookingId=<%= payment.getBookingID()%>'" style="cursor: pointer;">
                                <p><i class="fas fa-hashtag text-muted"></i> <strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                                <p><i class="fas fa-calendar-check text-muted"></i> <strong>Booking ID:</strong> <%= payment.getBookingID()%></p>
                                <p><i class="fas fa-calendar-alt text-muted"></i> <strong>Payment Date:</strong> <%= payment.getPaymentDate()%></p>
                                <p><i class="fas fa-credit-card text-muted"></i> <strong>Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                            </div>
                            <div class="payment-info">
                                <div onclick="window.location.href='admin-view-booking.jsp?bookingId=<%= payment.getBookingID()%>'" style="cursor: pointer;">
                                    <p class="amount">RM <%= String.format("%.2f", payment.getAmount())%></p>
                                    <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().toLowerCase().replace(" ", "-") : ""%>">
                                        <% if ("Pending".equals(payment.getPaymentStatus())) { %>
                                            <i class="fas fa-clock"></i> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                        <% } else if ("Confirmed".equals(payment.getPaymentStatus())) { %>
                                            <i class="fas fa-check-circle"></i> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                        <% } else if ("Completed".equals(payment.getPaymentStatus())) { %>
                                            <i class="fas fa-check-double"></i> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                        <% } else if ("Cancelled".equals(payment.getPaymentStatus())) { %>
                                            <i class="fas fa-times-circle"></i> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                        <% } else { %>
                                            <i class="fas fa-info-circle"></i> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                        <% } %>
                                    </span>
                                </div>
                                <div class="action-buttons">
                                    <% if ("Pending".equals(payment.getPaymentStatus())) {%>
                                    <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                        <input type="hidden" name="paymentStatus" value="Confirmed">
                                        <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                        <button type="submit" class="action-btn verify-btn" onclick="return confirm('Are you sure you want to verify payment <%= payment.getPaymentID()%>?')"><i class="fas fa-check"></i> Verify</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                        <input type="hidden" name="paymentStatus" value="Cancelled">
                                        <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                        <button type="submit" class="action-btn reject-btn" onclick="return confirm('Are you sure you want to reject payment <%= payment.getPaymentID()%>?')"><i class="fas fa-times"></i> Reject</button>
                                    </form>
                                    <% if ("Bank Transfer".equals(payment.getPaymentType())) {%>
                                    <button class="action-btn view-proof-btn" onclick="viewProofOfPayment('<%= request.getContextPath()%><%= payment.getProofOfPayment()%>')"><i class="fas fa-eye"></i> View Proof</button>
                                    <% } %>
                                    <% } else if ("Confirmed".equals(payment.getPaymentStatus())) { %>
                                    <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                        <input type="hidden" name="paymentStatus" value="Completed">
                                        <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                        <button type="submit" class="action-btn verify-btn" onclick="return confirm('Are you sure you want to mark payment <%= payment.getPaymentID()%> as completed?')"><i class="fas fa-check-double"></i> Complete</button>
                                    </form>
                                    <% } else if ("Completed".equals(payment.getPaymentStatus())) { %>
                                    <button class="action-btn verify-btn" disabled><i class="fas fa-check-double"></i> Completed</button>
                                    <% } else if ("Cancelled".equals(payment.getPaymentStatus())) { %>
                                    <button class="action-btn cancel-btn" disabled><i class="fas fa-times-circle"></i> Cancelled</button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </li>
                    <% } %>
                </ul>
                <% }%>

                <div class="timestamp"><i class="fas fa-clock"></i> Last updated: <%= currentDateTime%></div>
            </div>
        </div>

        <%@ include file="../include/scripts.html" %>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const filterButtons = document.querySelectorAll('.filter-btn');
                const paymentCards = document.querySelectorAll('#paymentCardsList .payment-item');
                const searchInput = document.getElementById('searchInput');
                const pendingFilter = document.getElementById('pendingFilter');
                const statusCounts = {
                    'Pending': document.getElementById('pendingCount'),
                    'Confirmed': document.getElementById('confirmedCount'),
                    'Completed': document.getElementById('completedCount'),
                    'Cancelled': document.getElementById('cancelledCount'),
                    'all': document.getElementById('allCount')
                };

                // Prevent action buttons from triggering card navigation
                document.querySelectorAll('.action-btn').forEach(button => {
                    button.addEventListener('click', function(e) {
                        e.stopPropagation();
                    });
                });

                // Prevent form submissions from triggering card navigation
                document.querySelectorAll('form').forEach(form => {
                    form.addEventListener('click', function(e) {
                        e.stopPropagation();
                    });
                });

                function updateStatusCounts() {
                    const counts = {
                        'Pending': 0,
                        'Confirmed': 0,
                        'Completed': 0,
                        'Cancelled': 0
                    };

                    paymentCards.forEach(card => {
                        const status = card.getAttribute('data-status');
                        if (status && counts.hasOwnProperty(status)) {
                            counts[status]++;
                        }
                    });

                    // Update all counts
                    Object.keys(counts).forEach(status => {
                        if (statusCounts[status]) {
                            statusCounts[status].textContent = counts[status];
                        }
                    });

                    // Update total count
                    statusCounts['all'].textContent = paymentCards.length;
                }

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
                        
                        // Remove active class from select
                        pendingFilter.classList.remove('active');
                        
                        if (status === 'Pending') {
                            const pendingContainer = document.querySelector('.pending-filter-container');
                            pendingContainer.classList.add('show');
                            pendingFilter.style.display = 'inline-block';
                            pendingFilter.classList.add('active');
                            filterCards(status, pendingFilter.value);
                        } else {
                            const pendingContainer = document.querySelector('.pending-filter-container');
                            pendingContainer.classList.remove('show');
                            pendingFilter.style.display = 'none';
                            filterCards(status);
                        }
                    });
                });

                pendingFilter.addEventListener('change', function () {
                    this.classList.add('active');
                    filterCards('Pending', this.value);
                });

                searchInput.addEventListener('input', function () {
                    const searchText = this.value;
                    searchCards(searchText);
                });

                // Initial filter and count update
                filterCards('Pending');
                updateStatusCounts();
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