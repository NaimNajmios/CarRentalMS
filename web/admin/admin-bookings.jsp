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
        <title>CarRent - Admin Booking Management</title>
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

            .sidebar .nav-item#pragma once
            {
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

            .filter-buttons {
                margin-bottom: 1.5rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 1rem;
            }

            .filter-buttons .left-buttons {
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
            }

            .filter-buttons button {
                padding: 0.5rem 1rem;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
                background-color: #f8f9fa;
                color: #333;
                font-size: 0.9rem;
                transition: all 0.15s ease-in-out;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .filter-buttons button:hover {
                background-color: #e9ecef;
                transform: translateY(-1px);
            }

            .filter-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .filter-buttons button .count {
                background-color: rgba(0, 0, 0, 0.1);
                padding: 0.1rem 0.4rem;
                border-radius: 10px;
                font-size: 0.8rem;
            }

            .filter-buttons button.active .count {
                background-color: rgba(255, 255, 255, 0.2);
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

            .booking-table .status-Confirmed {
                color: #004085;
                background-color: #cce5ff;
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

            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
            }

            .hidden {
                display: none !important;
            }

            .new-booking-btn {
                padding: 0.5rem 1rem;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
            }

            .new-booking-btn:hover {
                background-color: #218838;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .new-booking-btn i {
                font-size: 0.9rem;
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
                    <h2><i class="fas fa-calendar-check"></i> Booking Management</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search bookings..." class="form-control">
                    </div>
                </div>

                <div class="filter-buttons">
                    <div class="left-buttons">
                        <button class="active" onclick="filterBookings('all')"><i class="fas fa-list"></i> All <span class="count" id="allCount">0</span></button>
                        <button onclick="filterBookings('Pending')"><i class="fas fa-clock"></i> Pending <span class="count" id="pendingCount">0</span></button>
                        <button onclick="filterBookings('Confirmed')"><i class="fas fa-check-circle"></i> Confirmed <span class="count" id="confirmedCount">0</span></button>
                        <button onclick="filterBookings('Completed')"><i class="fas fa-check-double"></i> Completed <span class="count" id="completedCount">0</span></button>
                        <button onclick="filterBookings('Cancelled')"><i class="fas fa-times-circle"></i> Cancelled <span class="count" id="cancelledCount">0</span></button>
                    </div>
                    <a href="admin-create-booking.jsp" class="new-booking-btn">
                        <i class="fas fa-plus"></i>
                        New Booking
                    </a>
                </div>

                <%
                    UIAccessObject uiAccessObject = new UIAccessObject();
                    List<Booking> bookings = new ArrayList<>();
                    String errorMessage = null;
                    try {
                        bookings = uiAccessObject.getAllBookingDetails();
                    } catch (Exception e) {
                        errorMessage = "An error occurred while fetching bookings: " + e.getMessage();
                        Logger.getLogger(getClass().getName()).log(Level.SEVERE, "Error fetching bookings", e);
                    }

                    if (errorMessage != null) {
                %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= errorMessage%>
                </div>
                <%
                } else {
                %>
                <table class="booking-table">
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> Booking ID</th>
                            <th><i class="fas fa-user"></i> Client ID</th>
                            <th><i class="fas fa-car"></i> Vehicle ID</th>
                            <th><i class="fas fa-calendar-plus"></i> Start Date</th>
                            <th><i class="fas fa-calendar-minus"></i> End Date</th>
                            <th><i class="fas fa-dollar-sign"></i> Total Cost</th>
                            <th><i class="fas fa-info-circle"></i> Status</th>
                        </tr>
                    </thead>
                    <tbody id="bookingTableBody">
                        <% for (Booking booking : bookings) {%>
                        <tr class="booking-row" data-status="<%= booking.getBookingStatus()%>" onclick="window.location='admin-view-booking.jsp?bookingId=<%= booking.getBookingId() %>'" style="cursor: pointer;">
                            <td><%= booking.getBookingId()%></td>
                            <td><%= booking.getClientId()%></td>
                            <td><%= booking.getVehicleId()%></td>
                            <td><%= booking.getBookingStartDate()%></td>
                            <td><%= booking.getBookingEndDate()%></td>
                            <td><%= booking.getTotalCost()%></td>
                            <td>
                                <% if ("Pending".equals(booking.getBookingStatus())) { %>
                                    <span class="status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus() : ""%>"><i class="fas fa-clock"></i> <%= booking.getBookingStatus()%></span>
                                <% } else if ("Confirmed".equals(booking.getBookingStatus())) { %>
                                    <span class="status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus() : ""%>"><i class="fas fa-check-circle"></i> <%= booking.getBookingStatus()%></span>
                                <% } else if ("Completed".equals(booking.getBookingStatus())) { %>
                                    <span class="status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus() : ""%>"><i class="fas fa-check-double"></i> <%= booking.getBookingStatus()%></span>
                                <% } else if ("Cancelled".equals(booking.getBookingStatus())) { %>
                                    <span class="status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus() : ""%>"><i class="fas fa-times-circle"></i> <%= booking.getBookingStatus()%></span>
                                <% } else { %>
                                    <span class="status-<%= booking.getBookingStatus() != null ? booking.getBookingStatus() : ""%>"><i class="fas fa-info-circle"></i> <%= booking.getBookingStatus()%></span>
                                <% } %>
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
                <div class="timestamp"><i class="fas fa-clock"></i> Last updated: <%= new SimpleDateFormat("yyyy-MM-dd hh:mm a z").format(new Date())%></div>
                <%
                    }
                %>
            </main>
        </div>

        <%@ include file="../include/scripts.html" %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const filterButtons = document.querySelectorAll('.filter-buttons button');
                const bookingRows = document.querySelectorAll('.booking-row');
                const searchInput = document.getElementById('searchInput');
                const statusCounts = {
                    'all': document.getElementById('allCount'),
                    'Pending': document.getElementById('pendingCount'),
                    'Confirmed': document.getElementById('confirmedCount'),
                    'Completed': document.getElementById('completedCount'),
                    'Cancelled': document.getElementById('cancelledCount')
                };

                function updateStatusCounts() {
                    const counts = {
                        'Pending': 0,
                        'Confirmed': 0,
                        'Completed': 0,
                        'Cancelled': 0
                    };

                    bookingRows.forEach(row => {
                        const status = row.getAttribute('data-status');
                        if (status && counts.hasOwnProperty(status)) {
                            counts[status]++;
                        }
                    });

                    // Update all counts
                    Object.keys(counts).forEach(status => {
                        if (statusCounts[status]) {
                            statusCounts[status].textContent = counts[status];
                        }
                    });

                    // Update total count
                    statusCounts['all'].textContent = bookingRows.length;
                }

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

                searchInput.addEventListener('input', function () {
                    const searchText = this.value;
                    searchBookings(searchText);
                });

                // Initial filter and count update
                filterBookings('all');
                updateStatusCounts();
            });
        </script>
    </body>
</html>