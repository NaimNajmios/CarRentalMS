<%-- 
    Document   : viewAllVehicle
    Created on : May 7, 2025, 5:25:50 PM
    Author     : nadhi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Database.vehicleDAO, Vehicles.Vehicles" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Vehicle Management</title>
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

            .vehicle-table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-top: 1rem;
            }

            .vehicle-table th, .vehicle-table td {
                padding: 1rem;
                text-align: left;
                font-size: 0.95rem;
                color: #555;
            }

            .vehicle-table th {
                background-color: #f8f9fa;
                color: #34495e;
                font-weight: 600;
                border-bottom: 2px solid #dee2e6;
            }

            .vehicle-table td {
                border-bottom: 1px solid #dee2e6;
            }

            .vehicle-table tr:hover {
                background-color: #f1f3f5;
            }

            .vehicle-table .status-Available {
                color: #155724;
                background-color: #d4edda;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .vehicle-table .status-NotAvailable {
                color: #721c24;
                background-color: #f8d7da;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .availability-cell {
                min-width: 120px;
            }

            .btn-sm {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                margin: 0 0.2rem;
            }

            .alert {
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid transparent;
                border-radius: 0.375rem;
            }

            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
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
            }
        </style>
    </head>
    <body>
        <%@ include file="../include/admin-header.jsp" %>
        
        <div class="wrapper">
            <%@ include file="../include/admin-sidebar.jsp" %>
            
            <div class="dashboard-content">
                <%
                    String message = request.getParameter("message");
                    String messageType = request.getParameter("type");
                    if (message != null && messageType != null) {
                %>
                <div class="alert alert-<%= messageType%> alert-dismissible fade show" role="alert">
                    <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-triangle" %> me-2"></i>
                    <%= message%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%
                    }
                %>

                <div class="dashboard-header">
                    <h2><i class="fas fa-car"></i> Vehicle Management</h2>
                    <a href="addVehicle.jsp" class="btn btn-success">
                        <i class="fas fa-plus"></i> Add New Vehicle
                    </a>
                </div>

                <div class="search-box mb-3">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Search by ID, model, brand, rate..." onkeyup="filterTable()">
                </div>

                <div class="table-responsive">
                    <table class="vehicle-table" id="vehicleTable">
                        <thead>
                            <tr>
                                <th><i class="fas fa-id-badge"></i> Vehicle ID</th>
                                <th><i class="fas fa-car"></i> Model</th>
                                <th><i class="fas fa-tag"></i> Brand</th>
                                <th><i class="fas fa-money-bill-wave"></i> Rate/Day (RM)</th>
                                <th><i class="fas fa-check-circle"></i> Availability</th>
                                <th class="text-center"><i class="fas fa-cogs"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Vehicles> list = vehicleDAO.getAllVehicles();
                                for (Vehicles v : list) {
                            %>
                            <tr>
                                <td><%= v.getVehicleID()%></td>
                                <td><%= v.getModel()%></td>
                                <td><%= v.getBrand()%></td>
                                <td><%= v.getRatePerDay()%></td>
                                <td class="availability-cell">
                                    <span class="status-<%= v.isAvailability() ? "Available" : "NotAvailable"%>">
                                        <%= v.isAvailability() ? "Available" : "Not Available"%>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="viewVehicle.jsp?id=<%= v.getVehicleID()%>" class="btn btn-info btn-sm" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="editVehicle.jsp?id=<%= v.getVehicleID()%>" class="btn btn-warning btn-sm" title="Edit Vehicle">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="deleteVehicle.jsp?id=<%= v.getVehicleID()%>" class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Are you sure you want to delete this vehicle?');" title="Delete Vehicle">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>

                <div class="timestamp">
                    <i class="fas fa-clock"></i> Last updated: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date())%>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function filterTable() {
                var input = document.getElementById("searchInput");
                var filter = input.value.toUpperCase();
                var table = document.getElementById("vehicleTable");
                var tr = table.getElementsByTagName("tr");

                for (var i = 1; i < tr.length; i++) {
                    var td = tr[i].getElementsByTagName("td");
                    var found = false;
                    
                    // Search through all columns except the last one (actions)
                    for (var j = 0; j < td.length - 1; j++) {
                        if (td[j]) {
                            var txtValue = td[j].textContent || td[j].innerText;
                            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                found = true;
                                break;
                            }
                        }
                    }
                    
                    tr[i].style.display = found ? "" : "none";
                }
            }
        </script>
    </body>
</html>

