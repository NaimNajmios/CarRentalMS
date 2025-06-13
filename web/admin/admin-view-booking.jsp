<%@ page import="Booking.Booking"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="User.Client"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - View Booking Details</title>
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
            .dashboard-content {
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
            .back-link {
                text-decoration: none;
                color: #fff;
                font-weight: bold;
                padding: 0.5rem 1rem;
                background-color: #007bff;
                border-radius: 4px;
                transition: background-color 0.15s ease-in-out;
            }
            .back-link:hover {
                background-color: #0056b3;
            }
            .alert {
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid transparent;
                border-radius: 0.375rem;
            }
            .details-card-wrapper {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-top: 1rem;
                padding: 1.5rem;
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 2rem;
            }
            .action-section {
                padding: 1.5rem;
                border: 1px solid #e9ecef;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                min-height: 300px;
            }
            .action-section h3 {
                color: #333;
                margin-bottom: 1.5rem;
                font-size: 1.2rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e0e0e0;
            }
            .action-group {
                margin-bottom: 1.5rem;
            }
            .action-group h4 {
                font-size: 1rem;
                color: #495057;
                margin-bottom: 0.75rem;
            }
            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }
            .action-btn {
                display: flex;
                align-items: center;
                padding: 0.75rem 1rem;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.2s ease;
                cursor: pointer;
                width: 100%;
            }
            .action-btn i {
                margin-right: 0.75rem;
                font-size: 1.1rem;
            }
            .action-btn.edit {
                background-color: #fff3cd;
                color: #856404;
            }
            .action-btn.edit:hover {
                background-color: #ffeeba;
            }
            .action-btn.print {
                background-color: #e2e3e5;
                color: #383d41;
            }
            .action-btn.print:hover {
                background-color: #d6d8db;
            }
            .status-select {
                width: 100%;
                padding: 0.75rem 1rem;
                border: 1px solid #ced4da;
                border-radius: 6px;
                font-size: 1rem;
                color: #495057;
                background-color: #fff;
                cursor: pointer;
                transition: border-color 0.15s ease-in-out;
            }
            .status-select:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }
            .status-select option {
                padding: 0.5rem;
            }
            .status-select option[value="Pending"] {
                color: #856404;
                background-color: #fff3cd;
            }
            .status-select option[value="Confirmed"] {
                color: #155724;
                background-color: #d4edda;
            }
            .status-select option[value="Cancelled"] {
                color: #721c24;
                background-color: #f8d7da;
            }
            .status-select option[value="Completed"] {
                color: #004085;
                background-color: #cce5ff;
            }
            .update-status-btn {
                margin-top: 1rem;
                padding: 0.75rem 1rem;
                background-color: #007bff;
                color: #fff;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.15s ease-in-out;
                width: 100%;
            }
            .update-status-btn:hover {
                background-color: #0056b3;
            }
            .update-status-btn:disabled {
                background-color: #6c757d;
                cursor: not-allowed;
            }
            .booking-section-wrapper {
                grid-column: 1 / -1;
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 2rem;
                background-color: #f8f9fa;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                overflow: hidden;
            }
            .detail-section.booking-info-only {
                grid-column: 1;
                background-color: transparent;
                border: none;
                box-shadow: none;
                padding: 1.5rem;
            }
            .vehicle-image-section {
                grid-column: 2;
                padding: 1.5rem;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background-color: #fff;
                border-left: 1px solid #e9ecef;
            }
            .vehicle-image-section img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .vehicle-image-section .no-image {
                text-align: center;
                color: #6c757d;
                padding: 2rem;
                background-color: #f8f9fa;
                border-radius: 8px;
                width: 100%;
            }
            .detail-section h3 {
                font-size: 1.4rem;
                color: #333;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e0e0e0;
            }
            .detail-section p {
                margin-bottom: 1rem;
                font-size: 1rem;
                color: #555;
                line-height: 1.5;
            }
            .detail-section strong {
                color: #333;
                font-weight: 600;
            }
            .status-badge {
                display: inline-block;
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
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
            .vehicle-image-container {
                display: none;
            }
            .timestamp {
                text-align: right;
                font-size: 0.9rem;
                color: #7f8c8d;
                margin-top: 1rem;
                grid-column: 1 / -1;
            }
            .no-info {
                color: #777;
            }
            @media (max-width: 992px) {
                .booking-section-wrapper {
                    grid-template-columns: 1fr;
                }
                .vehicle-image-section {
                    border-left: none;
                    border-top: 1px solid #e9ecef;
                }
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
                .dashboard-content {
                    padding: 1.5rem;
                }
                .dashboard-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
            }
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                border-radius: 4px;
                color: #fff;
                font-weight: 500;
                z-index: 1000;
                display: none;
                animation: slideIn 0.5s ease-out;
            }
            .notification.success {
                background-color: #28a745;
            }
            .notification.error {
                background-color: #dc3545;
            }
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
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
            <div class="dashboard-content">
                <%
                    Logger logger = Logger.getLogger("admin-view-booking.jsp");
                    String bookingId = request.getParameter("bookingId");
                    Booking booking = null;
                    Vehicle vehicle = null;
                    Client client = null;
                    Payment payment = null;
                    String errorMessage = null;

                    if (bookingId != null && !bookingId.trim().isEmpty()) {
                        UIAccessObject uiAccessObject = new UIAccessObject();
                        try {
                            booking = uiAccessObject.getBookingByBookingId(bookingId);
                            if (booking != null) {
                                if (booking.getVehicleId() != null && !booking.getVehicleId().isEmpty()) {
                                    vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
                                }
                                if (booking.getClientId() != null && !booking.getClientId().isEmpty()) {
                                    client = uiAccessObject.getClientDataByClientID(booking.getClientId());
                                }
                                payment = uiAccessObject.getPaymentByBookingId(bookingId);
                            } else {
                                errorMessage = "Booking with ID " + bookingId + " not found.";
                            }
                        } catch (Exception e) {
                            errorMessage = "Error fetching booking details: " + e.getMessage();
                            logger.log(Level.SEVERE, "Error fetching booking details", e);
                        }
                    } else {
                        errorMessage = "Booking ID not provided.";
                    }

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                %>
                <% if (errorMessage != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= errorMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <div class="dashboard-header">
                    <h2>Booking Details</h2>
                    <a href="admin-bookings.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Bookings</a>
                </div>
                <% if (booking != null) {%>
                <div class="details-card-wrapper">
                    <div class="booking-section-wrapper">
                        <div class="detail-section booking-info-only">
                            <h3>Booking Information</h3>
                            <p><strong>Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                            <p><strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                            <p><strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                            <p><strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                            <p><strong>Duration:</strong>
                                <% if (booking.getBookingStartDate() != null && booking.getBookingEndDate() != null) {
                                        try {
                                            Date startDate = sdf.parse(booking.getBookingStartDate());
                                            Date endDate = sdf.parse(booking.getBookingEndDate());
                                            long diff = endDate.getTime() - startDate.getTime();
                                            long days = diff / (24 * 60 * 60 * 1000) + 1;
                                            out.print(days + (days == 1 ? " day" : " days"));
                                        } catch (Exception e) {
                                            out.print("N/A");
                                        }
                                    } else {
                                        out.print("N/A");
                                    }
                                %>
                            </p>
                            <p><strong>Total Cost:</strong> RM <%= booking.getTotalCost() != null ? booking.getTotalCost() : "N/A"%></p>
                            <p><strong>Status:</strong> <span class="status-badge status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>"><%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%></span></p>
                        </div>
                        <div class="vehicle-image-section">
                            <% if (vehicle != null && vehicle.getVehicleImagePath() != null && !vehicle.getVehicleImagePath().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= vehicle.getVehicleImagePath() %>" alt="<%= vehicle.getVehicleBrand() %> <%= vehicle.getVehicleModel() %>" class="img-fluid">
                            <% } else { %>
                                <div class="no-image">
                                    <i class="fas fa-car fa-3x mb-3"></i>
                                    <p>No vehicle image available</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <div class="detail-section client-details-card">
                        <h3>Client Information</h3>
                        <% if (client != null) {%>
                        <p><strong>Client ID:</strong> <%= client.getClientID()%></p>
                        <p><strong>Name:</strong> <%= client.getName()%></p>
                        <p><strong>Email:</strong> <%= client.getEmail()%></p>
                        <p><strong>Phone:</strong> <%= client.getPhoneNumber()%></p>
                        <% } else { %>
                        <div class="alert alert-warning">
                            Client information not available.
                        </div>
                        <% } %>
                    </div>
                    <div class="detail-section vehicle-info-card">
                        <h3>Vehicle Information</h3>
                        <% if (vehicle != null) {%>
                        <div class="vehicle-details-card">
                            <p><strong>Vehicle ID:</strong> <%= vehicle.getVehicleId()%></p>
                            <p><strong>Brand:</strong> <%= vehicle.getVehicleBrand()%></p>
                            <p><strong>Model:</strong> <%= vehicle.getVehicleModel()%></p>
                            <p><strong>Year:</strong> <%= vehicle.getVehicleYear()%></p>
                            <p><strong>Type:</strong> <%= vehicle.getVehicleCategory()%></p>
                            <p><strong>License Plate:</strong> <%= vehicle.getVehicleRegistrationNo()%></p>
                            <p><strong>Rental Rate:</strong> RM <%= vehicle.getVehicleRatePerDay()%></p>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning">
                            Vehicle information not available.
                        </div>
                        <% } %>
                    </div>
                    <div class="detail-section payment-info-card">
                        <h3>Payment Information</h3>
                        <% if (payment != null) {%>
                        <p><strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                        <p><strong>Payment Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                        <p><strong>Amount:</strong> RM <%= payment.getAmount()%></p>
                        <p><strong>Payment Status:</strong> <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%></p>
                        <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A"%></p>
                        <p><strong>Invoice Number:</strong> <%= payment.getInvoiceNumber() != null ? payment.getInvoiceNumber() : "N/A"%></p>
                        <p><strong>Handled By:</strong> <%= payment.getHandledBy() != null ? payment.getHandledBy() : "N/A"%></p>
                        <% if (payment.getProofOfPayment() != null && !payment.getProofOfPayment().isEmpty()) { %>
                        <p><strong>Proof of Payment:</strong> 
                            <button class="action-btn view-proof-btn" onclick="viewProofOfPayment('<%= request.getContextPath()%><%= payment.getProofOfPayment()%>')">
                                <i class="fas fa-file-pdf"></i> View Proof
                            </button>
                        </p>
                        <% } else { %>
                        <p><strong>Proof of Payment:</strong> Not available</p>
                        <% } %>
                        <% } else { %>
                        <div class="alert alert-warning">
                            Payment information not available.
                        </div>
                        <% }%>
                    </div>
                    <div class="action-section">
                        <h3>Booking Actions</h3>
                        <% if (booking != null) { %>
                            <div class="action-group">
                                <h4>Change Status</h4>
                                <select class="status-select" id="bookingStatus">
                                    <option value="Pending" <%= "Pending".equals(booking.getBookingStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Confirmed" <%= "Confirmed".equals(booking.getBookingStatus()) ? "selected" : "" %>>Confirmed</option>
                                    <option value="Cancelled" <%= "Cancelled".equals(booking.getBookingStatus()) ? "selected" : "" %>>Cancelled</option>
                                    <option value="Completed" <%= "Completed".equals(booking.getBookingStatus()) ? "selected" : "" %>>Completed</option>
                                </select>
                                <button class="update-status-btn" onclick="updateBookingStatus('<%= booking.getBookingId() %>')">
                                    <i class="fas fa-sync-alt"></i> Update Status
                                </button>
                            </div>
                            <div class="action-group">
                                <h4>Other Actions</h4>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="window.location.href='edit-booking.jsp?bookingId=<%= booking.getBookingId() %>'">
                                        <i class="fas fa-edit"></i> Edit Booking Details
                                    </button>
                                    <button class="action-btn print" onclick="window.print()">
                                        <i class="fas fa-print"></i> Print Booking Details
                                    </button>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="alert alert-warning">
                                No booking available for actions.
                            </div>
                        <% } %>
                    </div>
                    <div class="timestamp">
                        Last updated: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date())%>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-info">
                    No booking details to display.
                </div>
                <% }%>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <div id="notification" class="notification"></div>
        <script>
            function showNotification(message, isSuccess) {
                const notification = document.getElementById('notification');
                notification.textContent = message;
                notification.className = 'notification ' + (isSuccess ? 'success' : 'error');
                notification.style.display = 'block';
                
                setTimeout(() => {
                    notification.style.display = 'none';
                }, 3000);
            }

            function updateBookingStatus(bookingId) {
                const newStatus = document.getElementById('bookingStatus').value;
                if (confirm('Are you sure you want to change the booking status to ' + newStatus + '?')) {
                    fetch('update-booking-status.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'bookingId=' + bookingId + '&status=' + newStatus
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showNotification(data.message, true);
                            // Reload the page after a short delay to show the notification
                            setTimeout(() => {
                                location.reload();
                            }, 1000);
                        } else {
                            showNotification(data.message, false);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showNotification('Error updating booking status. Please try again.', false);
                    });
                }
            }

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