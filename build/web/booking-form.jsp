<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page import="User.User" %>
<%@ page import="User.Client" %>

<%
    // Retrieve user and client objects from session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Client loggedInClient = (Client) session.getAttribute("loggedInClient");

    // Redirect to login if user or client not logged in
    if (loggedInUser == null || loggedInClient == null || loggedInUser.getUserID() == null || loggedInUser.getUserID().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+make+a+booking.&type=warning");
        return;
    }

    // Get vehicleId from query parameter, parse to int
    String vehicleId = request.getParameter("vehicleId");
    int vehicleIdInt = 0;

    if (vehicleId == null || vehicleId.trim().isEmpty()) {
        response.sendRedirect("cars.jsp");
        return;
    }

    try {
        vehicleIdInt = Integer.parseInt(vehicleId);
    } catch (NumberFormatException e) {
        response.sendRedirect("cars.jsp");
        return;
    }

    // Fetch vehicle data
    UIAccessObject uiAccessObject = new UIAccessObject();
    Vehicle vehicle = null;

    try {
        vehicle = uiAccessObject.getVehicleById(vehicleIdInt);
    } catch (Exception e) {
        response.sendRedirect("cars.jsp");
        return;
    }

    if (vehicle == null || !vehicle.getVehicleAvailablity()) {
        response.sendRedirect("cars.jsp");
        return;
    }

    String vehicleImagePath = vehicle.getVehicleImagePath() != null && !vehicle.getVehicleImagePath().isEmpty()
            ? vehicle.getVehicleImagePath()
            : "images/default-vehicle.jpg";

    // Use dynamic user and client IDs from session
    String clientId = loggedInClient.getClientID();
    String createdBy = loggedInUser.getUserID();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String currentDate = sdf.format(new Date());

    // Get booked dates for the vehicle
    List<LocalDate> bookedDates = uiAccessObject.getBookedDatesForVehicle(vehicleIdInt);
    String bookedDatesJson = "[";
    if (bookedDates != null && !bookedDates.isEmpty()) {
        for (int i = 0; i < bookedDates.size(); i++) {
            bookedDatesJson += "\"" + bookedDates.get(i).toString() + "\"";
            if (i < bookedDates.size() - 1) {
                bookedDatesJson += ",";
            }
        }
    }
    bookedDatesJson += "]";
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Booking Form</title>
        <%@ include file="include/client-css.html" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <style>
            .booking-section {
                padding: 3rem 0;
            }
            .booking-container {
                display: flex;
                flex-wrap: wrap;
                gap: 2rem;
                max-width: 960px;
                margin: 0 auto;
            }
            .vehicle-info {
                flex: 1 0 100%; /* Full width on small screens */
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 1.5rem;
                background: #f9f9f9;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 1.5rem;
            }
            @media (min-width: 768px) {
                .vehicle-info {
                    flex: 0 0 40%;
                    align-items: flex-start;
                }
            }
            .vehicle-image {
                width: 100%;
                max-height: 200px;
                object-fit: cover;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 1rem;
            }
            .vehicle-details {
                text-align: center;
            }
            @media (min-width: 768px) {
                .vehicle-details {
                    text-align: left;
                }
            }
            .booking-form {
                flex: 1 0 100%; /* Full width on small screens */
                background: #fff;
                padding: 1.5rem;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            @media (min-width: 768px) {
                .booking-form {
                    flex: 0 0 55%;
                }
            }
            .booking-form h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 1.25rem;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .form-group label {
                display: block;
                font-weight: 500;
                color: #34495e;
                margin-bottom: 0.5rem;
            }
            .form-control {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #ced4da;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 1rem;
            }
            .submit-btn {
                background-color: #007bff;
                border: none;
                color: #fff;
                padding: 0.75rem 1.5rem;
                font-size: 1.1rem;
                font-weight: 500;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: 100%;
            }
            .submit-btn:hover {
                background-color: #0056b3;
            }
            .error-message {
                color: #dc3545;
                font-size: 0.9rem;
                margin-top: 0.25rem;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="booking-section">
            <div class="container">
                <div class="booking-container">
                    <div class="vehicle-info">
                        <img src="<%= vehicleImagePath%>" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>" class="vehicle-image">
                        <div class="vehicle-details">
                            <h3><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h3>
                            <p class="text-muted">Rate: RM<%= vehicle.getVehicleRatePerDay()%>/day</p>
                        </div>
                    </div>
                    <div class="booking-form">
                        <h2>Book This Vehicle</h2>
                        <form action="booking-confirmation.jsp" method="post" onsubmit="return validateForm()">
                            <input type="hidden" name="vehicleId" value="<%= vehicleId%>">
                            <input type="hidden" name="assignedDate" value="<%= currentDate%>">
                            <input type="hidden" name="clientId" value="<%= clientId%>">
                            <input type="hidden" name="createdBy" value="<%= createdBy%>">
                            <div class="form-group">
                                <label for="bookingDate">Booking Date</label>
                                <input type="date" class="form-control" id="bookingDate" name="bookingDate" value="<%= currentDate%>" readonly>
                                <small class="text-muted">Today's date (readonly)</small>
                            </div>
                            <div class="form-group">
                                <label for="startDate">Start Date</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" required min="<%= currentDate%>">
                            </div>
                            <div class="form-group">
                                <label for="endDate">End Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" required min="<%= currentDate%>">
                            </div>
                            <div class="form-group">
                                <label for="totalCost">Total Cost (RM)</label>
                                <input type="number" step="0.01" class="form-control" id="totalCost" name="totalCost" placeholder="0.00" readonly>
                                <small class="text-muted">Calculated automatically</small>
                            </div>
                            <button type="submit" class="submit-btn">Proceed to Confirmation</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>

        <%@ include file="include/scripts.html" %>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            const startDateInput = document.getElementById("startDate");
            const endDateInput = document.getElementById("endDate");
            const totalCostInput = document.getElementById("totalCost");
            const ratePerDay = <%= vehicle.getVehicleRatePerDay()%>;
            const bookedDates = JSON.parse('<%= bookedDatesJson%>');
            const MAX_BOOKING_DAYS = 30; // Maximum booking duration in days

            // Function to validate date selection
            function validateDateSelection(startDate, endDate) {
                const start = new Date(startDate);
                const end = new Date(endDate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                // Check if dates are valid
                if (isNaN(start.getTime()) || isNaN(end.getTime())) {
                    return { valid: false, message: "Please select valid dates" };
                }

                // Check if start date is in the past
                if (start < today) {
                    return { valid: false, message: "Start date cannot be in the past" };
                }

                // Check if end date is before start date
                if (end < start) {
                    return { valid: false, message: "End date must be after start date" };
                }

                // Check booking duration
                const daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
                if (daysDiff > MAX_BOOKING_DAYS) {
                    return { valid: false, message: `Maximum booking duration is ${MAX_BOOKING_DAYS} days` };
                }

                // Check if any selected dates are booked
                const selectedDates = [];
                let currentDate = new Date(start);
                while (currentDate <= end) {
                    selectedDates.push(currentDate.toISOString().split('T')[0]);
                    currentDate.setDate(currentDate.getDate() + 1);
                }

                const hasBookedDates = selectedDates.some(date => bookedDates.includes(date));
                if (hasBookedDates) {
                    return { valid: false, message: "Selected dates include unavailable dates" };
                }

                return { valid: true };
            }

            // Function to calculate total cost
            function calculateTotalCost() {
                const startDateValue = startDateInput.value;
                const endDateValue = endDateInput.value;

                if (startDateValue && endDateValue) {
                    const validation = validateDateSelection(startDateValue, endDateValue);
                    if (!validation.valid) {
                        totalCostInput.value = "";
                        showError(validation.message);
                        return;
                    }

                    const startDate = new Date(startDateValue);
                    const endDate = new Date(endDateValue);
                    const daysDiff = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
                    const totalCost = daysDiff * ratePerDay;
                    totalCostInput.value = totalCost.toFixed(2);
                    hideError();
                }
            }

            // Function to show error message
            function showError(message) {
                let errorDiv = document.getElementById("dateError");
                if (!errorDiv) {
                    errorDiv = document.createElement("div");
                    errorDiv.id = "dateError";
                    errorDiv.className = "alert alert-danger mt-2";
                    startDateInput.parentNode.appendChild(errorDiv);
                }
                errorDiv.textContent = message;
            }

            // Function to hide error message
            function hideError() {
                const errorDiv = document.getElementById("dateError");
                if (errorDiv) {
                    errorDiv.remove();
                }
            }

            // Initialize Flatpickr for start date
            flatpickr(startDateInput, {
                enableTime: false,
                dateFormat: "Y-m-d",
                minDate: "<%= currentDate%>",
                disable: bookedDates,
                onChange: function (selectedDates, dateStr, instance) {
                    endDatePicker.set("minDate", dateStr);
                    calculateTotalCost();
                }
            });

            // Initialize Flatpickr for end date
            const endDatePicker = flatpickr(endDateInput, {
                enableTime: false,
                dateFormat: "Y-m-d",
                minDate: "<%= currentDate%>",
                disable: bookedDates,
                onChange: calculateTotalCost
            });

            // Add form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const startDateValue = startDateInput.value;
                const endDateValue = endDateInput.value;

                if (!startDateValue || !endDateValue) {
                    e.preventDefault();
                    showError("Please select both start and end dates");
                    return;
                }

                const validation = validateDateSelection(startDateValue, endDateValue);
                if (!validation.valid) {
                    e.preventDefault();
                    showError(validation.message);
                }
            });
        </script>
    </body>
</html>