<%@page import="User.Client"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="Database.UIAccessObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="Booking.Booking"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>

<%
    // Initialize logger
    Logger logger = Logger.getLogger("booking-confirmation.jsp");

    UIAccessObject uiAccessObject = new UIAccessObject();
    logger.info("Created UIAccessObject");

    // Retrieve form data from booking-form.jsp
    String vehicleId = request.getParameter("vehicleId");
    String clientId = request.getParameter("clientId");
    String assignedDate = request.getParameter("assignedDate");
    String bookingDate = request.getParameter("bookingDate");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String totalCost = request.getParameter("totalCost");
    String createdBy = request.getParameter("createdBy");
    String bookingStatus = "Pending";

    // Create a Booking object
    Booking booking = new Booking(clientId, vehicleId, assignedDate, bookingDate, startDate, endDate, totalCost, bookingStatus, createdBy);

    Vehicle vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
    logger.info("Retrieved vehicle details: " + vehicle);

    // Client
    Client client = uiAccessObject.getClientDataByClientID(booking.getClientId());
    logger.info("Retrieved client details: " + client);

    String vehicleImagePath = vehicle.getVehicleImagePath();
    logger.info("Retrieved vehicle image path: " + vehicle.getVehicleImagePath());

    // Get current date and time
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date()); // e.g., 2025-05-16 04:50 PM +08
    logger.info("Current date/time: " + currentDateTime);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Booking Confirmation</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .confirmation-section {
                padding: 3rem 0;
            }
            .confirmation-container {
                max-width: 960px;
                margin: 0 auto;
                background: #fff;
                padding: 2rem;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            .vehicle-info {
                display: flex;
                align-items: center;
                gap: 1.5rem;
                margin-bottom: 2rem;
            }
            .vehicle-image {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            .vehicle-details h3 {
                margin: 0;
                font-size: 1.5rem;
                color: #2c3e50;
            }
            .vehicle-details p {
                margin: 0.5rem 0;
                color: #34495e;
            }
            .details-section {
                margin-bottom: 2rem;
            }
            .details-section h4 {
                font-size: 1.25rem;
                color: #2c3e50;
                margin-bottom: 1rem;
            }
            .details-section p {
                margin: 0.5rem 0;
                color: #7f8c8d;
            }
            .confirmation-actions {
                display: flex;
                gap: 1rem;
            }
            .confirm-btn, .cancel-btn {
                padding: 0.75rem 1.5rem;
                font-size: 1.1rem;
                font-weight: 500;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: 100%;
            }
            .confirm-btn {
                background-color: #28a745;
                color: #fff;
                border: none;
            }
            .confirm-btn:hover {
                background-color: #218838;
            }
            .cancel-btn {
                background-color: #dc3545;
                color: #fff;
                border: none;
            }
            .cancel-btn:hover {
                background-color: #c82333;
            }
            @media (max-width: 768px) {
                .vehicle-info {
                    flex-direction: column;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="confirmation-section">
            <div class="container">
                <div class="confirmation-container">
                    <h2>Booking Confirmation</h2>
                    <p class="text-muted">Please review your booking and client details below before confirming.</p>

                    <div class="vehicle-info">
                        <img src="<%= vehicleImagePath%>" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>" class="vehicle-image">
                        <div class="vehicle-details">
                            <h3><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h3>
                            <p>Rate: RM<%= vehicle.getVehicleRatePerDay()%>/day</p>
                        </div>
                    </div>

                    <div class="details-section">
                        <h4>Client Details</h4>
                        <p><strong>Name:</strong> <%= client.getName()%></p>
                        <p><strong>Client ID:</strong> <%= client.getClientID()%></p>
                        <p><strong>Email:</strong> <%= client.getEmail()%></p>
                        <p><strong>Phone:</strong> <%= client.getPhoneNumber()%></p>
                    </div>

                    <div class="details-section">
                        <h4>Booking Details</h4>
                        <p><strong>Start Date:</strong> <%= booking.getBookingStartDate()%></p>
                        <p><strong>End Date:</strong> <%= booking.getBookingEndDate()%></p>
                        <p><strong>Assigned Date:</strong> <%= booking.getAssignedDate()%></p>
                        <p><strong>Total Cost:</strong> RM<%= booking.getTotalCost()%></p>
                        <p><strong>Confirmation Date:</strong> <%= currentDateTime%></p>
                    </div>

                    <div class="confirmation-actions">
                        <form action="VehicleBooking" method="post">
                            <input type="hidden" name="vehicleId" value="<%= booking.getVehicleId()%>">
                            <input type="hidden" name="clientId" value="<%= booking.getClientId()%>">
                            <input type="hidden" name="assignedDate" value="<%= booking.getAssignedDate()%>">
                            <input type="hidden" name="bookingDate" value="<%= booking.getBookingDate()%>">
                            <input type="hidden" name="startDate" value="<%= booking.getBookingStartDate()%>">
                            <input type="hidden" name="endDate" value="<%= booking.getBookingEndDate()%>">
                            <input type="hidden" name="totalCost" value="<%= booking.getTotalCost()%>">
                            <input type="hidden" name="bookingStatus" value="<%= booking.getBookingStatus()%>">
                            <input type="hidden" name="createdBy" value="<%= booking.getCreatedBy()%>">
                            <button type="submit" class="confirm-btn">Confirm Booking</button>
                        </form>
                        <form action="cars.jsp" method="get">
                            <button type="submit" class="cancel-btn">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>

        <%@ include file="include/scripts.html" %>
    </body>
</html>