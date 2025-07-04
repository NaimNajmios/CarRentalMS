<%@ page import="Booking.Booking"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="User.Client"%>
<%@ page import="User.Admin"%>
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
        <title>CarRent - Edit Booking</title>
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
            .edit-form {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 2rem;
            }
            .form-section {
                margin-bottom: 2rem;
            }
            .form-section h3 {
                font-size: 1.4rem;
                color: #333;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e0e0e0;
            }
            .form-group {
                margin-bottom: 1.5rem;
            }
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: #495057;
            }
            .form-control {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #ced4da;
                border-radius: 4px;
                font-size: 1rem;
                transition: border-color 0.15s ease-in-out;
            }
            .form-control:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }
            .form-control:disabled {
                background-color: #e9ecef;
                cursor: not-allowed;
            }
            .btn-group {
                display: flex;
                gap: 1rem;
                margin-top: 2rem;
            }
            .btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 4px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .btn-primary {
                background-color: #007bff;
                color: #fff;
            }
            .btn-primary:hover {
                background-color: #0056b3;
            }
            .btn-secondary {
                background-color: #6c757d;
                color: #fff;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
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
            .readonly-info {
                background-color: #f8f9fa;
                padding: 1rem;
                border-radius: 4px;
                margin-bottom: 1rem;
            }
            .readonly-info p {
                margin: 0;
                color: #6c757d;
            }
            .readonly-info strong {
                color: #495057;
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
                    Logger logger = Logger.getLogger("edit-booking.jsp");
                    String bookingId = request.getParameter("bookingId");
                    Booking booking = null;
                    Vehicle vehicle = null;
                    Client client = null;
                    Payment payment = null;
                    String errorMessage = null;

                    // Retrieve admin object from session
                    Admin loggedInAdmin = (Admin) session.getAttribute("loggedInAdmin");
                    
                    // Redirect to login if admin not logged in
                    if (loggedInAdmin == null || loggedInAdmin.getAdminID() == null || loggedInAdmin.getAdminID().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+edit+bookings.&type=warning");
                        return;
                    }

                    String adminId = loggedInAdmin.getAdminID();
                    logger.log(Level.INFO, "Admin ID: {0}", adminId);

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
                %>
                <% if (errorMessage != null) {%>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= errorMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <div class="dashboard-header">
                    <h2><i class="fas fa-edit"></i> Edit Booking</h2>
                    <a href="admin-view-booking.jsp?bookingId=<%= bookingId %>" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Booking Details
                    </a>
                </div>
                <% if (booking != null) {%>
                <form class="edit-form" id="editBookingForm" action="update-booking.jsp" method="POST">
                    <div class="form-section">
                        <h3><i class="fas fa-info-circle"></i> Booking Information</h3>
                        <div class="readonly-info">
                            <input type="hidden" name="bookingId" value="<%= bookingId %>">
                            <input type="hidden" name="adminId" value="<%= ((Admin)session.getAttribute("loggedInAdmin")).getAdminID() %>">
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Booking ID:</strong> <%= bookingId %></p>
                            <p><i class="fas fa-calendar-alt text-muted"></i> <strong>Booking Date:</strong> <%= booking.getBookingDate() %></p>
                        </div>
                        <div class="form-group">
                            <label for="startDate"><i class="fas fa-calendar-plus"></i> Start Date</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                   value="<%= booking.getBookingStartDate() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="endDate"><i class="fas fa-calendar-minus"></i> End Date</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" 
                                   value="<%= booking.getBookingEndDate() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="totalCost"><i class="fas fa-dollar-sign"></i> Total Cost (RM)</label>
                            <input type="number" class="form-control" id="totalCost" name="totalCost" 
                                   value="<%= booking.getTotalCost() %>" step="0.01" required>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-user"></i> Client Information</h3>
                        <% if (client != null) {%>
                        <div class="readonly-info">
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Client ID:</strong> <%= client.getClientID() %></p>
                            <p><i class="fas fa-user text-muted"></i> <strong>Name:</strong> <%= client.getName() %></p>
                            <p><i class="fas fa-envelope text-muted"></i> <strong>Email:</strong> <%= client.getEmail() %></p>
                            <p><i class="fas fa-phone text-muted"></i> <strong>Phone:</strong> <%= client.getPhoneNumber() %></p>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Client information not available.
                        </div>
                        <% } %>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-car"></i> Vehicle Information</h3>
                        <% if (vehicle != null) {%>
                        <div class="readonly-info">
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Vehicle ID:</strong> <%= vehicle.getVehicleId() %></p>
                            <p><i class="fas fa-tag text-muted"></i> <strong>Brand:</strong> <%= vehicle.getVehicleBrand() %></p>
                            <p><i class="fas fa-car text-muted"></i> <strong>Model:</strong> <%= vehicle.getVehicleModel() %></p>
                            <p><i class="fas fa-calendar text-muted"></i> <strong>Year:</strong> <%= vehicle.getVehicleYear() %></p>
                            <p><i class="fas fa-cog text-muted"></i> <strong>Type:</strong> <%= vehicle.getVehicleCategory() %></p>
                            <p><i class="fas fa-id-card text-muted"></i> <strong>License Plate:</strong> <%= vehicle.getVehicleRegistrationNo() %></p>
                            <p><i class="fas fa-dollar-sign text-muted"></i> <strong>Rental Rate:</strong> RM <%= vehicle.getVehicleRatePerDay() %></p>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Vehicle information not available.
                        </div>
                        <% } %>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-credit-card"></i> Payment Information</h3>
                        <% if (payment != null) {%>
                        <div class="readonly-info">
                            <p><i class="fas fa-hashtag text-muted"></i> <strong>Payment ID:</strong> <%= payment.getPaymentID() %></p>
                            <p><i class="fas fa-credit-card text-muted"></i> <strong>Payment Type:</strong> <%= payment.getPaymentType() %></p>
                            <p><i class="fas fa-dollar-sign text-muted"></i> <strong>Amount:</strong> RM <%= payment.getAmount() %></p>
                            <p><i class="fas fa-info-circle text-muted"></i> <strong>Payment Status:</strong> <%= payment.getPaymentStatus() %></p>
                            <p><i class="fas fa-calendar-alt text-muted"></i> <strong>Payment Date:</strong> <%= payment.getPaymentDate() %></p>
                            <p><i class="fas fa-file-invoice text-muted"></i> <strong>Invoice Number:</strong> <%= payment.getInvoiceNumber() %></p>
                            <p><i class="fas fa-user-tie text-muted"></i> <strong>Handled By:</strong> <%= payment.getHandledBy() %></p>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Payment information not available.
                        </div>
                        <% }%>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <a href="admin-view-booking.jsp?bookingId=<%= booking.getBookingId() %>" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
                <% } else { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    No booking details to display.
                </div>
                <% }%>
            </div>
        </div>
        <div id="notification" class="notification"></div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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

            document.getElementById('editBookingForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const formData = new FormData(this);
                const bookingId = formData.get('bookingId');
                const adminId = formData.get('adminId');
                const startDate = formData.get('startDate');
                const endDate = formData.get('endDate');
                const totalCost = formData.get('totalCost');
                
                // Log form data for debugging
                console.log('Form Data:', {
                    bookingId: bookingId,
                    adminId: adminId,
                    startDate: startDate,
                    endDate: endDate,
                    totalCost: totalCost
                });
                
                // Validate all required fields
                if (!bookingId || !adminId || !startDate || !endDate || !totalCost) {
                    showNotification("All fields are required. Please ensure you are logged in as admin.", false);
                    return false;
                }
                
                // Validate dates
                const start = new Date(startDate);
                const end = new Date(endDate);
                if (start > end) {
                    showNotification("Start date must be before or on the end date", false);
                    return false;
                }
                
                // Submit form data
                fetch('update-booking.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification(data.message, true);
                        setTimeout(() => {
                            window.location.href = 'admin-view-booking.jsp?bookingId=' + bookingId;
                        }, 1000);
                    } else {
                        showNotification(data.message, false);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Error updating booking. Please try again.', false);
                });
            });

            // Simple date validation
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            const totalCostInput = document.getElementById('totalCost');
            const ratePerDay = <%= vehicle != null ? vehicle.getVehicleRatePerDay() : 0 %>;

            // Update end date minimum when start date changes
            startDateInput.addEventListener('change', function() {
                if (endDateInput.value && endDateInput.value < this.value) {
                    endDateInput.value = this.value;
                }
                calculateTotalCost();
            });

            // Update start date maximum when end date changes
            endDateInput.addEventListener('change', function() {
                if (startDateInput.value && startDateInput.value > this.value) {
                    startDateInput.value = this.value;
                }
                calculateTotalCost();
            });

            function calculateTotalCost() {
                const startDateValue = startDateInput.value;
                const endDateValue = endDateInput.value;

                if (startDateValue && endDateValue) {
                    const startDate = new Date(startDateValue);
                    const endDate = new Date(endDateValue);

                    if (startDate <= endDate) {
                        const timeDifference = endDate.getTime() - startDate.getTime();
                        const numberOfDays = Math.ceil(timeDifference / (1000 * 3600 * 24)) + 1; // Include both start and end date
                        const total = numberOfDays * ratePerDay;
                        totalCostInput.value = total.toFixed(2);
                    } else {
                        totalCostInput.value = "";
                    }
                } else {
                    totalCostInput.value = "";
                }
            }

            // Form validation
            document.getElementById('editBookingForm').addEventListener('submit', function(e) {
                const startDate = new Date(startDateInput.value);
                const endDate = new Date(endDateInput.value);
                
                if (startDate > endDate) {
                    e.preventDefault();
                    showNotification("Start date must be before or on the end date.", false);
                    return false;
                }
                
                if (!totalCostInput.value) {
                    e.preventDefault();
                    showNotification("Please select a valid start and end date to calculate the total cost.", false);
                    return false;
                }
                
                return true;
            });
        </script>
    </body>
</html> 