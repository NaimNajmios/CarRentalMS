<%@ page import="Booking.Booking"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Admin Dashboard</title>
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

            .sidebar .nav-item {
                margin-bottom: 0.5rem;
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

            .search-box {
                position: relative;
                max-width: 300px;
            }

            .search-box input {
                padding: 0.6rem 1rem 0.6rem 2.2rem;
                border: 1px solid #ced4da;
                border-radius: 0.375rem;
                width: 100%;
                font-size: 0.9rem;
                transition: border-color 0.2s;
            }

            .search-box input:focus {
                border-color: #007bff;
                outline: none;
            }

            .search-box i {
                position: absolute;
                left: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }

            .stats-section {
                margin-bottom: 2rem;
            }

            .stats-section h3 {
                font-size: 1.25rem;
                color: #333;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
            }

            .dashboard-card {
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 1.5rem;
                transition: transform 0.1s ease-in-out;
                display: flex;
                align-items: center;
                text-align: left;
            }

            .dashboard-card:hover {
                transform: scale(1.02);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .dashboard-card .icon {
                font-size: 2rem;
                color: #2563eb;
                margin-right: 1rem;
            }

            .card-content {
                flex-grow: 1;
            }

            .card-title {
                font-size: 1.1rem;
                font-weight: 600;
                color: #34495e;
                margin-bottom: 0.3rem;
            }

            .card-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: #2563eb;
            }

            .card-value.large {
                font-size: 2rem;
            }

            .card-subtitle {
                font-size: 0.9rem;
                color: #7f8c8d;
            }

            .filter-buttons {
                margin-bottom: 1.5rem;
            }

            .filter-buttons button {
                padding: 0.5rem 1rem;
                margin-right: 0.5rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
                background-color: #f8f9fa;
                color: #333;
                font-size: 0.9rem;
                transition: background-color 0.15s ease-in-out;
            }

            .filter-buttons button:hover {
                background-color: #e9ecef;
            }

            .filter-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .booking-table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-top: 1rem;
            }

            .booking-table th, .booking-table td {
                padding: 1rem;
                text-align: left;
                font-size: 0.95rem;
                color: #555;
            }

            .booking-table th {
                background-color: #f8f9fa;
                color: #34495e;
                font-weight: 600;
                border-bottom: 2px solid #dee2e6;
            }

            .booking-table td {
                border-bottom: 1px solid #dee2e6;
            }

            .booking-table tr:hover {
                background-color: #f1f3f5;
            }

            .booking-table .status-Pending {
                color: #85640a;
                background-color: #fff3cd;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .booking-table .status-Completed {
                color: #155724;
                background-color: #d4edda;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .booking-table .status-Cancelled {
                color: #721c24;
                background-color: #f8d7da;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
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

            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
            }

            .hidden {
                display: none !important;
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
                .search-box {
                    max-width: 100%;
                }
                .stats-grid {
                    grid-template-columns: 1fr;
                }
                .dashboard-card {
                    padding: 1rem;
                }
                .booking-table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                .booking-table thead, .booking-table tbody, .booking-table tr {
                    display: block;
                }
                .booking-table th, .booking-table td {
                    display: inline-block;
                    width: 100%;
                    box-sizing: border-box;
                }
                .booking-table th {
                    position: sticky;
                    top: 0;
                    background-color: #f8f9fa;
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

            <main class="dashboard-content">
                <div class="dashboard-header">
                    <h2>Admin Dashboard</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search dashboard..." class="form-control">
                    </div>
                </div>

                <%
                    UIAccessObject dao = new UIAccessObject();
                    DecimalFormat currencyFormat = new DecimalFormat("#,##0.00");
                    Logger logger = Logger.getLogger(this.getClass().getName());

                    int totalBookings = 0;
                    int completedBookings = 0;
                    int pendingBookings = 0;
                    int cancelledBookings = 0;
                    double totalRevenue = 0.0;
                    int totalVehicles = 0;
                    int availableVehicles = 0;
                    int totalClients = 0;

                    boolean hasError = false;
                    String errorMessage = "";

                    try {
                        totalBookings = dao.getTotalBookings();
                        completedBookings = dao.getBookingsByStatus("Completed");
                        pendingBookings = dao.getBookingsByStatus("Pending");
                        cancelledBookings = dao.getBookingsByStatus("Cancelled");
                        totalRevenue = dao.getTotalRevenue();
                        totalVehicles = dao.getTotalVehicles();
                        availableVehicles = dao.getAvailableVehicles();
                        totalClients = dao.getTotalClients();
                    } catch (Exception e) {
                        logger.log(Level.SEVERE, "Error fetching dashboard data", e);
                        hasError = true;
                        errorMessage = "An error occurred while loading dashboard data. Please try again later.";
                    }

                    if (hasError) {
                %>
                <div class="alert alert-danger" role="alert">
                    <%= errorMessage%>
                </div>
                <%
                    }
                %>

                <!-- Stats Section -->
                <div class="stats-section">
                    <h3>Overview</h3>
                    <div class="stats-grid">
                        <div class="dashboard-card">
                            <i class="fas fa-book icon"></i>
                            <div class="card-content">
                                <div class="card-title">Total Bookings</div>
                                <div class="card-value large"><%= totalBookings%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-check-circle icon"></i>
                            <div class="card-content">
                                <div class="card-title">Completed Bookings</div>
                                <div class="card-value"><%= completedBookings%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-clock icon"></i>
                            <div class="card-content">
                                <div class="card-title">Pending Bookings</div>
                                <div class="card-value"><%= pendingBookings%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-times-circle icon"></i>
                            <div class="card-content">
                                <div class="card-title">Cancelled Bookings</div>
                                <div class="card-value"><%= cancelledBookings%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-dollar-sign icon"></i>
                            <div class="card-content">
                                <div class="card-title">Total Revenue</div>
                                <div class="card-value large">RM <%= currencyFormat.format(totalRevenue)%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-car icon"></i>
                            <div class="card-content">
                                <div class="card-title">Total Vehicles</div>
                                <div class="card-value"><%= totalVehicles%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-car-side icon"></i>
                            <div class="card-content">
                                <div class="card-title">Available Vehicles</div>
                                <div class="card-value"><%= availableVehicles%></div>
                            </div>
                        </div>
                        <div class="dashboard-card">
                            <i class="fas fa-users icon"></i>
                            <div class="card-content">
                                <div class="card-title">Total Clients</div>
                                <div class="card-value"><%= totalClients%></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="timestamp">Last updated: <%= new SimpleDateFormat("yyyy-MM-dd hh:mm a z").format(new Date())%></div>
            </main>
        </div>

        <%@ include file="../include/scripts.html" %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Search functionality for dashboard cards
                const searchInput = document.getElementById('searchInput');
                const dashboardCards = document.querySelectorAll('.dashboard-card');

                searchInput.addEventListener('input', function () {
                    const searchText = this.value.toLowerCase();
                    dashboardCards.forEach(card => {
                        const text = card.textContent.toLowerCase();
                        if (text.includes(searchText)) {
                            card.classList.remove('hidden');
                        } else {
                            card.classList.add('hidden');
                        }
                    });
                });

                // Booking table search and filter functionality
                const bookingSearchInput = document.getElementById('bookingSearchInput');
                const filterButtons = document.querySelectorAll('.filter-buttons button');
                const bookingRows = document.querySelectorAll('.booking-row');

                function filterBookings(status) {
                    bookingRows.forEach(row => {
                        const rowStatus = row.getAttribute('data-status');
                        if (status === 'all' || rowStatus === status) {
                            row.classList.remove('hidden');
                        } else {
                            row.classList.add('hidden');
                        }
                    });
                }

                function searchBookings(searchText) {
                    bookingRows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        if (text.includes(searchText.toLowerCase())) {
                            row.classList.remove('hidden');
                        } else {
                            row.classList.add('hidden');
                        }
                    });
                }

                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const status = this.getAttribute('onclick').match(/'([^']+)'/)[1];
                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');
                        filterBookings(status);
                    });
                });

                bookingSearchInput.addEventListener('input', function () {
                    const searchText = this.value;
                    searchBookings(searchText);
                });

                // Initial filter for bookings
                filterBookings('all');
            });
        </script>
    </body>
</html>