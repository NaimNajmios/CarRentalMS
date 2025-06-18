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
            .btn-payment-action {
                padding: 0.75rem 1rem;
                border-radius: 6px;
                font-weight: 500;
                width: 100%;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .btn-payment-action i {
                margin-right: 0.75rem;
            }
            .btn-payment-action.confirm {
                background-color: #28a745;
                color: #fff;
            }
            .btn-payment-action.confirm:hover {
                background-color: #218838;
            }
            .btn-payment-action.complete {
                background-color: #17a2b8;
                color: #fff;
            }
            .btn-payment-action.complete:hover {
                background-color: #138496;
            }
            .btn-payment-action.reject {
                background-color: #dc3545;
                color: #fff;
            }
            .btn-payment-action.reject:hover {
                background-color: #c82333;
            }
            .btn-payment-action.disabled {
                background-color: #6c757d;
                color: #fff;
                cursor: not-allowed;
            }
            .btn-payment-action.view-proof {
                background-color: #6f42c1;
                color: #fff;
            }
            .btn-payment-action.view-proof:hover {
                background-color: #5a32a3;
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
                    String successMessage = null;

                    // Check for success or error messages in URL parameters
                    String success = request.getParameter("success");
                    String error = request.getParameter("error");

                    if ("true".equals(success)) {
                        successMessage = "Payment status updated successfully.";
                    } else if ("true".equals(error)) {
                        errorMessage = "An error occurred while updating payment status.";
                    }

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
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= errorMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <% if (successMessage != null) {%>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <div class="dashboard-header">
                    <h2><i class="fas fa-calendar-check"></i> Booking Details</h2>
                    <a href="admin-bookings.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Bookings</a>
                </div>
                <% if (booking != null) {%>
                <div class="details-card-wrapper">
                    <div class="booking-section-wrapper">
                        <div class="detail-section booking-info-only">
                            <h3><i class="fas fa-info-circle"></i> Booking Information</h3>
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                            <p><i class="fas fa-calendar-alt text-muted"></i> <strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                            <p><i class="fas fa-calendar-plus text-muted"></i> <strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                            <p><i class="fas fa-calendar-minus text-muted"></i> <strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                            <p><i class="fas fa-clock text-muted"></i> <strong>Duration:</strong>
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
                            <p><i class="fas fa-dollar-sign text-muted"></i> <strong>Total Cost:</strong> RM <%= booking.getTotalCost() != null ? booking.getTotalCost() : "N/A"%></p>
                            <p><i class="fas fa-info-circle text-muted"></i> <strong>Status:</strong> 
                                <span class="status-badge status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus().replace(" ", "") : ""%>">
                                    <% if ("Pending".equals(booking.getBookingStatus())) { %>
                                        <i class="fas fa-clock"></i> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%>
                                    <% } else if ("Confirmed".equals(booking.getBookingStatus())) { %>
                                        <i class="fas fa-check-circle"></i> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%>
                                    <% } else if ("Completed".equals(booking.getBookingStatus())) { %>
                                        <i class="fas fa-check-double"></i> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%>
                                    <% } else if ("Cancelled".equals(booking.getBookingStatus())) { %>
                                        <i class="fas fa-times-circle"></i> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%>
                                    <% } else { %>
                                        <i class="fas fa-info-circle"></i> <%= booking.getBookingStatus() != null ? booking.getBookingStatus() : "N/A"%>
                                    <% } %>
                                </span>
                            </p>
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
                        <h3><i class="fas fa-user"></i> Client Information</h3>
                        <% if (client != null) {%>
                        <p><i class="fas fa-hashtag text-muted"></i> <strong>Client ID:</strong> <%= client.getClientID()%></p>
                        <p><i class="fas fa-user text-muted"></i> <strong>Name:</strong> <%= client.getName()%></p>
                        <p><i class="fas fa-envelope text-muted"></i> <strong>Email:</strong> <%= client.getEmail()%></p>
                        <p><i class="fas fa-phone text-muted"></i> <strong>Phone:</strong> <%= client.getPhoneNumber()%></p>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Client information not available.
                        </div>
                        <% } %>
                    </div>
                    <div class="detail-section vehicle-info-card">
                        <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                        <% if (vehicle != null) {%>
                        <div class="vehicle-details-card">
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Vehicle ID:</strong> <%= vehicle.getVehicleId()%></p>
                            <p><i class="fas fa-tag text-muted"></i> <strong>Brand:</strong> <%= vehicle.getVehicleBrand()%></p>
                            <p><i class="fas fa-car text-muted"></i> <strong>Model:</strong> <%= vehicle.getVehicleModel()%></p>
                            <p><i class="fas fa-calendar text-muted"></i> <strong>Year:</strong> <%= vehicle.getVehicleYear()%></p>
                            <p><i class="fas fa-cog text-muted"></i> <strong>Type:</strong> <%= vehicle.getVehicleCategory()%></p>
                            <p><i class="fas fa-id-card text-muted"></i> <strong>License Plate:</strong> <%= vehicle.getVehicleRegistrationNo()%></p>
                            <p><i class="fas fa-dollar-sign text-muted"></i> <strong>Rental Rate:</strong> RM <%= vehicle.getVehicleRatePerDay()%></p>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Vehicle information not available.
                        </div>
                        <% } %>
                    </div>
                    <div class="detail-section payment-info-card">
                        <h3><i class="fas fa-credit-card"></i> Payment Information</h3>
                        <% if (payment != null) {%>
                        <p><i class="fas fa-hashtag text-muted"></i> <strong>Payment ID:</strong> <%= payment.getPaymentID()%></p>
                        <p><i class="fas fa-credit-card text-muted"></i> <strong>Payment Type:</strong> <%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></p>
                        <p><i class="fas fa-dollar-sign text-muted"></i> <strong>Amount:</strong> RM <%= payment.getAmount()%></p>
                        <p><i class="fas fa-info-circle text-muted"></i> <strong>Payment Status:</strong> 
                            <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>">
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
                        </p>
                        <p><i class="fas fa-calendar-alt text-muted"></i> <strong>Payment Date:</strong> <%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A"%></p>
                        <p><i class="fas fa-file-invoice text-muted"></i> <strong>Invoice Number:</strong> <%= payment.getInvoiceNumber() != null ? payment.getInvoiceNumber() : "N/A"%></p>
                        <p><i class="fas fa-user-tie text-muted"></i> <strong>Handled By:</strong> <%= payment.getHandledBy() != null ? payment.getHandledBy() : "N/A"%></p>
                        <% if (payment.getProofOfPayment() != null && !payment.getProofOfPayment().isEmpty()) { %>
                        <p><i class="fas fa-file-upload text-muted"></i> <strong>Proof of Payment:</strong> 
                            <button class="action-btn view-proof-btn" onclick="viewProofOfPayment('<%= request.getContextPath()%><%= payment.getProofOfPayment()%>')">
                                <i class="fas fa-file-pdf"></i> View Proof
                            </button>
                        </p>
                        <% } else { %>
                        <p><i class="fas fa-file-upload text-muted"></i> <strong>Proof of Payment:</strong> Not submitted yet</p>
                        <% } %>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Payment information not available.
                        </div>
                        <% }%>
                    </div>
                    <div class="action-section">
                        <h3><i class="fas fa-cogs"></i> Booking Actions</h3>
                        <% if (booking != null) { %>
                            <div class="action-group">
                                <h4><i class="fas fa-edit"></i> Change Status</h4>
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
                            <% if (payment != null) { %>
                            <div class="action-group">
                                <h4><i class="fas fa-credit-card"></i> Payment Actions</h4>
                                <% if ("Pending".equals(payment.getPaymentStatus())) {%>
                                <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="margin-bottom: 0.5rem;">
                                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                    <input type="hidden" name="paymentStatus" value="Confirmed">
                                    <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                    <input type="hidden" name="redirectTo" value="admin-view-booking.jsp?bookingId=<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn-payment-action confirm" title="Mark as Confirmed" onclick="return confirm('Are you sure you want to mark payment <%= payment.getPaymentID()%> as Confirmed?')">
                                        <i class="fas fa-check"></i> Mark as Confirmed
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="margin-bottom: 0.5rem;">
                                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                    <input type="hidden" name="paymentStatus" value="Cancelled">
                                    <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                    <input type="hidden" name="redirectTo" value="admin-view-booking.jsp?bookingId=<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn-payment-action reject" title="Reject Payment" onclick="return confirm('Are you sure you want to reject payment <%= payment.getPaymentID()%>?')">
                                        <i class="fas fa-times"></i> Reject Payment
                                    </button>
                                </form>
                                <% if ("Bank Transfer".equals(payment.getPaymentType()) && payment.getProofOfPayment() != null && !payment.getProofOfPayment().isEmpty()) {%>
                                <button class="btn-payment-action view-proof" onclick="viewProofOfPayment('<%= request.getContextPath()%><%= payment.getProofOfPayment()%>')" title="View Proof of Payment">
                                    <i class="fas fa-eye"></i> View Proof
                                </button>
                                <% } %>
                                <% } else if ("Confirmed".equals(payment.getPaymentStatus())) {%>
                                <form action="${pageContext.request.contextPath}/UpdatePaymentStatus" method="post" style="margin-bottom: 0.5rem;">
                                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentID()%>">
                                    <input type="hidden" name="paymentStatus" value="Completed">
                                    <input type="hidden" name="adminId" value="<%= loggedAdmin.getAdminID() %>">
                                    <input type="hidden" name="redirectTo" value="admin-view-booking.jsp?bookingId=<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn-payment-action complete" title="Mark as Completed" onclick="return confirm('Are you sure you want to mark payment <%= payment.getPaymentID()%> as Completed?')">
                                        <i class="fas fa-check-double"></i> Mark as Completed
                                    </button>
                                </form>
                                <% } else if ("Completed".equals(payment.getPaymentStatus())) { %>
                                <button class="btn-payment-action disabled" disabled title="Payment Completed">
                                    <i class="fas fa-check-double"></i> Payment Completed
                                </button>
                                <% } else if ("Cancelled".equals(payment.getPaymentStatus())) { %>
                                <button class="btn-payment-action disabled" disabled title="Payment Cancelled">
                                    <i class="fas fa-times-circle"></i> Payment Cancelled
                                </button>
                                <% } %>
                            </div>
                            <% } %>
                            <div class="action-group">
                                <h4><i class="fas fa-tools"></i> Other Actions</h4>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="window.location.href='edit-booking.jsp?bookingId=<%= booking.getBookingId() %>'">
                                        <i class="fas fa-edit"></i> Edit Booking Details
                                    </button>
                                    <button class="action-btn print" onclick="window.open('admin-booking-invoice.jsp?bookingId=<%= booking.getBookingId() %>', '_blank')">
                                        <i class="fas fa-print"></i> Print Booking Invoice
                                    </button>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No booking available for actions.
                            </div>
                        <% } %>
                    </div>
                    <div class="timestamp">
                        <i class="fas fa-clock"></i> Last updated: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date())%>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
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