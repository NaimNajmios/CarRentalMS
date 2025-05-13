<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle" %>

<%
    // Get vehicle ID from query parameter, parse to int
    String vehicleId = request.getParameter("vehicleId");
    int vehicleIdInt = 0;

    // Validate vehicleId and parse
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
        // Log the exception (in a real application, you'd log this properly)
        response.sendRedirect("cars.jsp");
        return;
    }

    // Check if vehicle exists and is available
    if (vehicle == null || !vehicle.getVehicleAvailablity()) {
        response.sendRedirect("cars.jsp");
        return;
    }

    // Set default image if vehicle image is null
    String vehicleImagePath = vehicle.getVehicleImagePath() != null && !vehicle.getVehicleImagePath().isEmpty()
            ? vehicle.getVehicleImagePath()
            : "images/default-vehicle.jpg";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Vehicle Details</title>
    <%@ include file="include/client-css.html" %>
<style>
    .vehicle-details-section {
        padding: 3rem 0;
    }
    .vehicle-details-container {
        background: #fff;
        padding: 2rem;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .vehicle-image-container {
        flex: 0 0 40%; /* Adjust width as needed */
        max-width: 40%;
        margin-right: 2rem;
    }
    .vehicle-image {
        width: 100%;
        max-height: 300px; /* Adjust max height as needed */
        object-fit: cover;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    .vehicle-info-container {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .vehicle-info-header {
        text-align: left;
        margin-bottom: 1.5rem;
    }
    .vehicle-info-header h2 {
        font-size: 2rem;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 0.5rem;
    }
    .vehicle-info-header .price {
        font-size: 1.5rem;
        font-weight: 600;
        color: #e74c3c;
    }
    .vehicle-info-header .price span {
        font-size: 1rem;
        color: #7f8c8d;
    }
    .vehicle-details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* Increased min width */
        gap: 0.75rem 1rem; /* Adjusted row and column gap */
        margin-bottom: 2rem;
    }
    .vehicle-details-grid dt {
        font-weight: 500;
        color: #34495e;
        grid-column: 1 / 2; /* Ensure label takes one column */
    }
    .vehicle-details-grid dd {
        color: #7f8c8d;
        font-size: 1rem;
        margin-bottom: 0; /* Removed default bottom margin */
        grid-column: 2 / 3; /* Ensure value takes the next column */
    }
    .book-now-btn {
        background-color: #007bff;
        border: none;
        padding: 0.75rem 2rem;
        font-size: 1.1rem;
        font-weight: 500;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-decoration: none;
        color: white;
        display: inline-block;
        text-align: center; /* Add this line to center the text */
    }
    .book-now-btn:hover {
        background-color: #0056b3;
    }

    /* Media query for smaller screens */
    @media (max-width: 768px) {
        .vehicle-details-container {
            flex-direction: column;
        }
        .vehicle-image-container {
            width: 100%;
            max-width: 100%;
            margin-right: 0;
            margin-bottom: 1.5rem;
        }
        .vehicle-image {
            max-height: none;
        }
        .vehicle-info-header {
            text-align: center;
        }
        .vehicle-details-grid {
            grid-template-columns: 1fr; /* Stack labels and values vertically */
        }
        .vehicle-details-grid dt {
            grid-column: 1 / 2; /* Reset for vertical layout */
            margin-bottom: 0.25rem; /* Add a little space below the label */
        }
        .vehicle-details-grid dd {
            grid-column: 1 / 2; /* Reset for vertical layout */
            margin-bottom: 0.75rem; /* Add more space below the value */
        }
        .book-now-btn {
            display: block;
            width: 100%;
            margin: 1rem auto 0;
            text-align: center; /* Already present for full-width button */
        }
    }
</style>
</head>
<body>
    <%@ include file="include/header.jsp" %>

    <section class="vehicle-details-section">
        <div class="container">
            <div class="vehicle-details-container d-flex">
                <div class="vehicle-image-container">
                    <img src="<%= vehicleImagePath %>" alt="<%= vehicle.getVehicleBrand() %> <%= vehicle.getVehicleModel() %>" class="vehicle-image">
                </div>

                <div class="vehicle-info-container">
                    <div class="vehicle-info-header">
                        <h2><%= vehicle.getVehicleBrand() %> <%= vehicle.getVehicleModel() %></h2>
                        <p class="price">RM<%= vehicle.getVehicleRatePerDay() %> <span>/day</span></p>
                    </div>

                    <div class="vehicle-details-grid">
                        <dt>Category</dt>
                        <dd><%= vehicle.getVehicleCategory() != null ? vehicle.getVehicleCategory() : "N/A" %></dd>

                        <dt>Brand</dt>
                        <dd><%= vehicle.getVehicleBrand() != null ? vehicle.getVehicleBrand() : "N/A" %></dd>

                        <dt>Model</dt>
                        <dd><%= vehicle.getVehicleModel() != null ? vehicle.getVehicleModel() : "N/A" %></dd>

                        <dt>Transmission</dt>
                        <dd><%= vehicle.getTransmissionType() != null ? vehicle.getTransmissionType() : "N/A" %></dd>

                        <dt>Fuel Type</dt>
                        <dd><%= vehicle.getVehicleFuelType() != null ? vehicle.getVehicleFuelType() : "N/A" %></dd>

                        <dt>Availability</dt>
                        <dd><%= vehicle.getVehicleAvailablity() ? "Available" : "Not Available" %></dd>
                    </div>

                    <a href="booking-form.jsp?vehicleId=<%= vehicle.getVehicleId() %>" class="book-now-btn">Book Now</a>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="include/footer.jsp" %>

    <%@ include file="include/scripts.html" %>
</body>
</html>