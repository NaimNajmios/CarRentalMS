<%@page import="User.Client"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="Database.UIAccessObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="Booking.Booking"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.util.logging.Level"%>

<%
    // Initialize logger
    Logger logger = Logger.getLogger("booking-confirmation.jsp");
    logger.setLevel(Level.INFO);
    logger.info("Starting booking confirmation process");

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

    logger.info("Retrieved form parameters - VehicleID: " + vehicleId + ", ClientID: " + clientId);

    // Create a Booking object
    Booking booking = new Booking(clientId, vehicleId, assignedDate, bookingDate, startDate, endDate, totalCost, bookingStatus, createdBy);
    logger.info("Created new Booking object");

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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            .confirmation-section {
                padding: 3rem 0;
                min-height: calc(100vh - 56px);
                display: flex;
                align-items: center;
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
                padding: 1rem;
                background: #f8f9fa;
                border-radius: 8px;
            }
            .vehicle-image {
                width: 200px;
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
                padding: 1.5rem;
                background: #f8f9fa;
                border-radius: 8px;
            }
            .details-section h4 {
                font-size: 1.25rem;
                color: #2c3e50;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #e9ecef;
            }
            .details-section p {
                margin: 0.75rem 0;
                color: #495057;
            }
            .details-section strong {
                color: #2c3e50;
                font-weight: 600;
            }
            .confirmation-actions {
                display: flex;
                gap: 1rem;
                margin-top: 2rem;
            }
            .confirm-btn, .cancel-btn {
                padding: 0.75rem 1.5rem;
                font-size: 1.1rem;
                font-weight: 500;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 100%;
                text-align: center;
                text-decoration: none;
                display: inline-block;
            }
            .confirm-btn {
                background-color: #28a745;
                color: #fff;
                border: none;
            }
            .confirm-btn:hover {
                background-color: #218838;
                transform: translateY(-1px);
            }
            .cancel-btn {
                background-color: #dc3545;
                color: #fff;
                border: none;
            }
            .cancel-btn:hover {
                background-color: #c82333;
                transform: translateY(-1px);
            }
            @media (max-width: 768px) {
                .vehicle-info {
                    flex-direction: column;
                    text-align: center;
                }
                .vehicle-image {
                    width: 100%;
                    max-width: 300px;
                }
                .confirmation-actions {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="confirmation-section">
            <div class="container">
                <div class="confirmation-container">
                    <h2 class="mb-4">Booking Confirmation</h2>
                    <p class="text-muted mb-4">Please review your booking and client details below before confirming.</p>

                    <div class="vehicle-info">
                        <img src="<%= vehicleImagePath%>" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>" class="vehicle-image">
                        <div class="vehicle-details">
                            <h3><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h3>
                            <p><i class="fas fa-tag me-2"></i>Rate: RM<%= vehicle.getVehicleRatePerDay()%>/day</p>
                        </div>
                    </div>

                    <div class="details-section">
                        <h4><i class="fas fa-user me-2"></i>Client Details</h4>
                        <p><strong>Name:</strong> <%= client.getName()%></p>
                        <p><strong>Client ID:</strong> <%= client.getClientID()%></p>
                        <p><strong>Email:</strong> <%= client.getEmail()%></p>
                        <p><strong>Phone:</strong> <%= client.getPhoneNumber()%></p>
                    </div>

                    <div class="details-section">
                        <h4><i class="fas fa-calendar-check me-2"></i>Booking Details</h4>
                        <p><strong>Start Date:</strong> <%= booking.getBookingStartDate()%></p>
                        <p><strong>End Date:</strong> <%= booking.getBookingEndDate()%></p>
                        <p><strong>Assigned Date:</strong> <%= booking.getAssignedDate()%></p>
                        <p><strong>Total Cost:</strong> RM<%= booking.getTotalCost()%></p>
                        <p><strong>Confirmation Date:</strong> <%= currentDateTime%></p>
                    </div>

                    <div class="confirmation-actions">
                        <form action="VehicleBooking" method="post" class="w-100">
                            <input type="hidden" name="vehicleId" value="<%= booking.getVehicleId()%>">
                            <input type="hidden" name="clientId" value="<%= booking.getClientId()%>">
                            <input type="hidden" name="assignedDate" value="<%= booking.getAssignedDate()%>">
                            <input type="hidden" name="bookingDate" value="<%= booking.getBookingDate()%>">
                            <input type="hidden" name="startDate" value="<%= booking.getBookingStartDate()%>">
                            <input type="hidden" name="endDate" value="<%= booking.getBookingEndDate()%>">
                            <input type="hidden" name="totalCost" value="<%= booking.getTotalCost()%>">
                            <input type="hidden" name="bookingStatus" value="<%= booking.getBookingStatus()%>">
                            <input type="hidden" name="createdBy" value="<%= booking.getCreatedBy()%>">
                            <button type="submit" class="confirm-btn">
                                <i class="fas fa-check-circle me-2"></i>Confirm Booking
                            </button>
                        </form>
                        <a href="cars.jsp" class="cancel-btn">
                            <i class="fas fa-times-circle me-2"></i>Cancel
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>
    </body>
</html>