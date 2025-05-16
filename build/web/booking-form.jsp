<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.temporal.ChronoUnit"%>

<%
    // Get vehicleId from query parameter, parse to int
    String vehicleId = request.getParameter("vehicleId");
    int vehicleIdInt = 0;
    String userid = "2000";

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

    // Assume createdBy is set from session (e.g., logged-in user ID), if not, set null
    String createdBy = (session.getAttribute("userId") != null) ? (String) session.getAttribute("userId") : null;
    if (createdBy == null) {
        createdBy = userid; // Fallback to the hardcoded userid if session is not set
    }

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
                            <input type="hidden" name="clientId" value="<%= userid%>">
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

                            const endDatePicker = flatpickr(endDateInput, {
                                enableTime: false,
                                dateFormat: "Y-m-d",
                                minDate: "<%= currentDate%>",
                                disable: bookedDates,
                                onChange: calculateTotalCost
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

                            function validateForm() {
                                const startDate = new Date(startDateInput.value);
                                const endDate = new Date(endDateInput.value);
                                if (startDate > endDate) {
                                    alert("Start date must be before or on the end date.");
                                    return false;
                                }
                                if (!totalCostInput.value) {
                                    alert("Please select a valid start and end date to calculate the total cost.");
                                    return false;
                                }
                                return true;
                            }
        </script>
    </body>
</html>