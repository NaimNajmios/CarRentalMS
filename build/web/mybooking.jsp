<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Booking.Booking"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="User.User" %>
<%@ page import="User.Client" %>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>

<%
    // Initialize logger
    Logger logger = Logger.getLogger("mybooking.jsp");
    logger.setLevel(Level.INFO);
    logger.info("Starting mybooking.jsp page load");

    // Retrieve user and client objects from session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Client loggedInClient = (Client) session.getAttribute("loggedInClient");

    // Redirect to login if user or client not logged in
    if (loggedInUser == null || loggedInClient == null || loggedInClient.getClientID() == null || loggedInClient.getClientID().isEmpty()) {
        logger.warning("Unauthorized access attempt - User or client not logged in");
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+view+your+bookings.&type=warning");
        return;
    }

    String clientId = loggedInClient.getClientID();
    logger.info("Retrieved client ID: " + clientId);

    UIAccessObject uiAccessObject = new UIAccessObject();
    logger.info("Created UIAccessObject instance");

    // Get all bookings by client ID
    List<Booking> allBookings = uiAccessObject.getAllBookingByClientID(clientId);
    logger.info("Retrieved " + (allBookings != null ? allBookings.size() : 0) + " bookings for client ID: " + clientId);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());
    logger.info("Current date/time: " + currentDateTime);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - My Bookings</title>
        <%@ include file="include/client-css.html" %>
        <style>
            .booking-history-section {
                padding: 2rem 0;
                background-color: #f8f9fa;
            }
            .booking-history-container {
                max-width: 1200px;
                margin: 2rem auto;
            }
            .booking-history-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                padding: 0 1rem;
            }
            .booking-history-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: #2c3e50;
                margin: 0;
            }
            .filter-buttons {
                margin-bottom: 1rem;
                padding: 0 1rem;
            }
            .filter-buttons button {
                padding: 0.5rem 1rem;
                margin-right: 0.5rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
                background-color: #f8f9fa;
                color: #333;
            }
            .filter-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
            .booking-cards-list {
                list-style: none;
                padding: 0;
            }
            .booking-item {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                overflow: hidden;
                transition: transform 0.1s ease-in-out;
                cursor: pointer;
                display: grid;
                grid-template-columns: 220px 1fr 180px;
                margin-bottom: 1.5rem;
            }
            .booking-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .booking-image-container {
                width: 220px;
                height: 100%;
                overflow: hidden;
            }
            .booking-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                background-color: #e9ecef;
            }
            .booking-details {
                padding: 1rem;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .booking-details p {
                margin-bottom: 0.3rem;
                font-size: 0.95rem;
                color: #555;
            }
            .booking-details strong {
                font-weight: 600;
                color: #34495e;
            }
            .booking-info {
                background-color: #f8f9fa;
                padding: 1rem;
                border-left: 1px solid #dee2e6;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .booking-info .total-cost {
                font-size: 1.1rem;
                font-weight: bold;
                color: #27ae60;
                margin-bottom: 0.5rem;
            }
            .booking-info .status {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-align: center;
            }
            .status-Pending { background-color: #fff3cd; color: #85640a; }
            .status-Completed { background-color: #cce5ff; color: #004085; }
            .status-Cancelled { background-color: #f8d7da; color: #721c24; }
            .no-bookings {
                text-align: center;
                color: #7f8c8d;
                padding: 2rem;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
                padding: 0 1rem;
            }
            .hidden {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <section class="booking-history-section">
            <div class="container">
                <%-- Message Display Area --%>
                <% String message = request.getParameter("message");
                   String messageType = request.getParameter("type");
                   if (message != null && !message.isEmpty()) {
                %>
                <div class="alert alert-<%= messageType != null ? messageType : "info" %> alert-dismissible fade show" role="alert">
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <div class="booking-history-container">
                    <div class="booking-history-header">
                        <h2>My Bookings</h2>
                        <p class="text-muted">Client ID: <%= clientId%></p>
                    </div>

                    <div class="filter-buttons">
                        <button class="filter-btn active" data-status="Pending">Pending</button>
                        <button class="filter-btn" data-status="Completed">Completed</button>
                        <button class="filter-btn" data-status="Cancelled">Cancelled</button>
                        <button class="filter-btn" data-status="all">All</button>
                    </div>

                    <% if (allBookings == null || allBookings.isEmpty()) { %>
                    <div class="no-bookings">No booking records found for this client.</div>
                    <% } else { %>
                    <ul class="booking-cards-list" id="bookingCardsList">
                        <% for (Booking booking : allBookings) { %>
                        <%
                            // Fetch vehicle details directly using vehicleId from Booking
                            Vehicle vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
                            // Normalize booking status
                            String bookingStatus = booking.getBookingStatus();
                            bookingStatus = bookingStatus != null ? bookingStatus.trim() : "";
                            // Debug: Print booking status to console
                            System.out.println("Booking ID: " + booking.getBookingId() + ", Status: " + bookingStatus);
                        %>
                        <li class="booking-item booking-card" data-status="<%= bookingStatus %>" onclick="window.location = 'booking-details.jsp?bookingId=<%= booking.getBookingId()%>'">
                            <div class="booking-image-container">
                                <img src="<%= vehicle != null ? vehicle.getVehicleImagePath() : "path/to/default/image.jpg"%>" alt="Vehicle Image" class="booking-image" onerror="this.src='path/to/default/image.jpg';">
                            </div>
                            <div class="booking-details">
                                <p><strong>Booking ID:</strong> <%= booking.getBookingId() != null ? booking.getBookingId() : "N/A"%></p>
                                <p><strong>Vehicle:</strong> <%= vehicle != null ? vehicle.getVehicleBrand() + " " + vehicle.getVehicleModel() : "N/A"%></p>
                                <p><strong>Start Date:</strong> <%= booking.getBookingStartDate() != null ? booking.getBookingStartDate() : "N/A"%></p>
                                <p><strong>End Date:</strong> <%= booking.getBookingEndDate() != null ? booking.getBookingEndDate() : "N/A"%></p>
                                <p><strong>Booking Date:</strong> <%= booking.getBookingDate() != null ? booking.getBookingDate() : "N/A"%></p>
                            </div>
                            <div class="booking-info">
                                <p class="total-cost">RM <%= booking.getTotalCost() != null ? String.format("%.2f", Double.parseDouble(booking.getTotalCost())) : "N/A"%></p>
                                <span class="status status-<%= bookingStatus.replace(" ", "") %>"><%= bookingStatus != null ? bookingStatus : "N/A"%></span>
                            </div>
                        </li>
                        <% } %>
                    </ul>
                    <% }%>

                    <div class="timestamp">Last updated: <%= currentDateTime%></div>
                </div>
            </div>
        </section>

        <%@ include file="include/footer.jsp" %>
        <%@ include file="include/scripts.html" %>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const filterButtons = document.querySelectorAll('.filter-btn');
                const bookingCards = document.querySelectorAll('#bookingCardsList .booking-item');
                const bookingCardsList = document.getElementById('bookingCardsList');
                const noBookingsMessage = document.querySelector('.no-bookings');

                // Function to filter cards by status
                function filterCards(status) {
                    let visibleCardsCount = 0;
                    bookingCards.forEach(card => {
                        const cardStatus = card.getAttribute('data-status').trim();
                        console.log("Filtering - Card Status: " + cardStatus + ", Filter: " + status); // Debug
                        if (status === 'all' || cardStatus === status) {
                            card.classList.remove('hidden');
                            visibleCardsCount++;
                        } else {
                            card.classList.add('hidden');
                        }
                    });

                    if (visibleCardsCount === 0) {
                        noBookingsMessage.style.display = 'block';
                        bookingCardsList.style.display = 'none';
                    } else {
                        noBookingsMessage.style.display = 'none';
                        bookingCardsList.style.display = 'block';
                    }
                }

                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const status = this.getAttribute('data-status');
                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');
                        filterCards(status);
                    });
                });

                // Initial load: show only pending
                filterCards('Pending');
            });
        </script>
    </body>
</html>