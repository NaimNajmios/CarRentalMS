<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="User.Client"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<%
    String errorMessage = null;
    String successMessage = null;
    UIAccessObject uiAccessObject = new UIAccessObject();
    List<Vehicle> availableVehicles = new ArrayList<>();
    List<Client> clients = new ArrayList<>();
    String currentDate = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);

    try {
        availableVehicles = uiAccessObject.getVehicleList();
        clients = uiAccessObject.getClientList();
    } catch (Exception e) {
        errorMessage = "An error occurred while loading data: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Booking - CarRent</title>
        <%@ include file="../include/admin-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
            .alert {
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid transparent;
                border-radius: 0.375rem;
            }
            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }
            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
            }
            .booking-form {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-top: 1rem;
                padding: 2rem;
            }
            .form-section {
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #eee;
            }
            .form-section h3 {
                color: #333;
                margin-bottom: 1rem;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #555;
            }
            .form-control {
                width: 100%;
                padding: 0.5rem;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 0.95rem;
            }
            .form-control:focus {
                border-color: #007bff;
                outline: none;
            }
            .submit-btn {
                background: #007bff;
                color: white;
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 500;
                width: 100%;
                transition: background-color 0.2s;
            }
            .submit-btn:hover {
                background: #0056b3;
            }
            .unavailable-dates {
                margin-top: 1rem;
                padding: 1rem;
                background: #f8f9fa;
                border-radius: 4px;
            }
            .unavailable-dates h4 {
                margin-bottom: 0.5rem;
                color: #495057;
            }
            .date-list {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            .date-item {
                background: #e9ecef;
                padding: 0.25rem 0.75rem;
                border-radius: 15px;
                font-size: 0.875rem;
                color: #495057;
            }
            .back-btn {
                padding: 0.6rem 1.2rem;
                background-color: #6c757d;
                color: white;
                border: none;
                border-radius: 0.375rem;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.2s;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
            }
            .back-btn:hover {
                background-color: #5a6268;
            }
            .back-btn i {
                font-size: 0.9rem;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
            }
            .flatpickr-day.disabled, .flatpickr-day.disabled:hover {
                background: #f4f4f4;
                color: #999;
                cursor: not-allowed;
                border: 1px solid #ddd;
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
            }
        </style>
    </head>
    <body>
        <header>
            <%@ include file="../include/admin-header.jsp" %>
        </header>
        <div class="wrapper">
            <%@ include file="../include/admin-sidebar.jsp" %>
            <main class="main-content">
                <div class="dashboard-header">
                    <h2>Create New Booking</h2>
                    <a href="admin-bookings.jsp" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Bookings
                    </a>
                </div>
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>
                <form action="${pageContext.request.contextPath}/CreateBooking" method="post" class="booking-form">
                    <div class="form-section">
                        <h3>Client Information</h3>
                        <div class="form-group">
                            <label for="clientId">Select Client</label>
                            <select name="clientId" id="clientId" class="form-control" required>
                                <option value="">Select a client</option>
                                <% for (Client client : clients) { %>
                                <option value="<%= client.getClientID() %>">
                                    <%= client.getClientID() %> - <%= client.getName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="form-section">
                        <h3>Vehicle Information</h3>
                        <div class="form-group">
                            <label for="vehicleId">Select Vehicle</label>
                            <select name="vehicleId" id="vehicleId" class="form-control" required onchange="checkVehicleAvailability(this.value)">
                                <option value="">Select a vehicle</option>
                                <% for (Vehicle vehicle : availableVehicles) { %>
                                <option value="<%= vehicle.getVehicleId() %>" data-rate="<%= vehicle.getVehicleRatePerDay() %>">
                                    <%= vehicle.getVehicleId() %> - <%= vehicle.getVehicleBrand() %> <%= vehicle.getVehicleModel() %> 
                                    (RM<%= vehicle.getVehicleRatePerDay() %>/day)
                                </option>
                                <% } %>
                            </select>
                            <div id="availabilityMessage"></div>
                            <div id="unavailableDates" class="unavailable-dates" style="display: none;">
                                <h4>Unavailable Dates</h4>
                                <div id="unavailableDatesList" class="date-list"></div>
                            </div>
                        </div>
                    </div>
                    <div class="form-section">
                        <h3>Booking Details</h3>
                        <div class="form-group">
                            <label for="startDate">Start Date</label>
                            <input type="text" name="startDate" id="startDate" class="form-control" required placeholder="Select start date">
                        </div>
                        <div class="form-group">
                            <label for="endDate">End Date</label>
                            <input type="text" name="endDate" id="endDate" class="form-control" required placeholder="Select end date">
                        </div>
                        <div class="form-group">
                            <label for="totalCost">Total Cost (RM)</label>
                            <input type="text" name="totalCost" id="totalCost" class="form-control" readonly required>
                        </div>
                        <input type="hidden" name="assignedDate" value="<%= currentDate %>">
                        <input type="hidden" name="bookingDate" value="<%= currentDate %>">
                        <input type="hidden" name="adminId" value="<%= session.getAttribute("adminId") %>">
                    </div>
                    <button type="submit" class="submit-btn">Create Booking</button>
                </form>
                <div class="timestamp">
                    Last updated: <%= new SimpleDateFormat("yyyy-MM-dd hh:mm a z").format(new Date()) %>
                </div>
            </main>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            let bookedDates = [];
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            const availabilityMessage = document.getElementById('availabilityMessage');
            const unavailableDatesDiv = document.getElementById('unavailableDates');
            const unavailableDatesList = document.getElementById('unavailableDatesList');

            // Initialize Flatpickr for startDate and endDate
            const startPicker = flatpickr("#startDate", {
                dateFormat: "Y-m-d",
                minDate: "<%= currentDate %>",
                disable: bookedDates,
                onChange: function(selectedDates) {
                    if (selectedDates.length > 0) {
                        endPicker.set('minDate', selectedDates[0]);
                        validateDates();
                    }
                }
            });

            const endPicker = flatpickr("#endDate", {
                dateFormat: "Y-m-d",
                minDate: "<%= currentDate %>",
                disable: bookedDates,
                onChange: function() {
                    validateDates();
                }
            });

            function formatDate(dateStr) {
                return new Date(dateStr).toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                });
            }

            function showMessage(message, type) {
                availabilityMessage.innerHTML = `<div class="alert alert-${type}">${message}</div>`;
            }

            function displayUnavailableDates(dates) {
                if (!dates || dates.length === 0) {
                    unavailableDatesDiv.style.display = 'none';
                    startPicker.set('disable', []);
                    endPicker.set('disable', []);
                    return;
                }
                unavailableDatesDiv.style.display = 'block';
                unavailableDatesList.innerHTML = '';
                dates.sort().forEach(date => {
                    const dateItem = document.createElement('div');
                    dateItem.className = 'date-item';
                    dateItem.textContent = formatDate(date);
                    unavailableDatesList.appendChild(dateItem);
                });
                startPicker.set('disable', dates);
                endPicker.set('disable', dates);
            }

            function checkVehicleAvailability(vehicleId) {
                if (!vehicleId) {
                    showMessage('Please select a vehicle', 'danger');
                    startPicker.set('disable', []);
                    endPicker.set('disable', []);
                    startPicker.setDate(null);
                    endPicker.setDate(null);
                    unavailableDatesDiv.style.display = 'none';
                    return;
                }
                showMessage('Checking availability...', 'info');
                fetch('${pageContext.request.contextPath}/GetVehicleBookedDates?vehicleId=' + vehicleId)
                    .then(response => response.json())
                    .then(dates => {
                        bookedDates = dates;
                        displayUnavailableDates(dates);
                        if (dates.length > 0) {
                            showMessage(`This vehicle has ${dates.length} booked dates`, 'warning');
                            // Clear dates if previously selected, as booked dates have changed
                            startPicker.setDate(null);
                            endPicker.setDate(null);
                        } else {
                            showMessage('This vehicle is available for all dates', 'success');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showMessage('Error checking availability', 'danger');
                    });
            }

            function validateDates() {
                const start = startPicker.selectedDates[0];
                const end = endPicker.selectedDates[0];
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                // Skip validation if either date is not selected
                if (!start || !end) {
                    return;
                }

                if (start < today) {
                    showMessage('Start date cannot be in the past', 'danger');
                    startPicker.setDate(null);
                    return;
                }

                if (end < start) {
                    showMessage('End date must be after start date', 'danger');
                    endPicker.setDate(null);
                    return;
                }

                const selectedDates = [];
                let current = new Date(start);
                while (current <= end) {
                    selectedDates.push(current.toISOString().split('T')[0]);
                    current.setDate(current.getDate() + 1);
                }

                const hasBookedDates = selectedDates.some(date => bookedDates.includes(date));
                if (hasBookedDates) {
                    showMessage('Selected dates include unavailable dates', 'danger');
                    startPicker.setDate(null);
                    endPicker.setDate(null);
                } else {
                    showMessage('Selected dates are available', 'success');
                    // Calculate total cost
                    const vehicleSelect = document.getElementById('vehicleId');
                    const selectedOption = vehicleSelect.options[vehicleSelect.selectedIndex];
                    const ratePerDay = parseFloat(selectedOption.dataset.rate);
                    const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;
                    const totalCost = ratePerDay * days;
                    document.getElementById('totalCost').value = totalCost.toFixed(2);
                }
            }

            document.querySelector('form').addEventListener('submit', function(e) {
                const start = startPicker.selectedDates[0];
                const end = endPicker.selectedDates[0];
                if (!start || !end) {
                    e.preventDefault();
                    showMessage('Please select both start and end dates', 'danger');
                    return;
                }
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                if (start < today) {
                    e.preventDefault();
                    showMessage('Start date cannot be in the past', 'danger');
                    startPicker.setDate(null);
                    return;
                }
                if (end < start) {
                    e.preventDefault();
                    showMessage('End date must be after start date', 'danger');
                    endPicker.setDate(null);
                    return;
                }
                const selectedDates = [];
                let current = new Date(start);
                while (current <= end) {
                    selectedDates.push(current.toISOString().split('T')[0]);
                    current.setDate(current.getDate() + 1);
                }
                const hasBookedDates = selectedDates.some(date => bookedDates.includes(date));
                if (hasBookedDates) {
                    e.preventDefault();
                    showMessage('Selected dates include unavailable dates', 'danger');
                    startPicker.setDate(null);
                    endPicker.setDate(null);
                }
            });
        </script>
    </body>
</html>