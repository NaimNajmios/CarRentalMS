<%-- 
    Document   : viewVehicle
    Created on : Jun 3, 2025, 12:21:29 PM
    Author     : nadhi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Database.vehicleDAO, Vehicles.Vehicles" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - View Vehicle Details</title>
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

            .vehicle-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 2rem;
            }

            .vehicle-image {
                width: 100%;
                height: 400px;
                object-fit: cover;
                border-radius: 8px 8px 0 0;
            }

            .vehicle-details {
                padding: 2rem;
            }

            .vehicle-title {
                color: #34495e;
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #f0f0f0;
            }

            .details-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1.5rem;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .detail-label {
                color: #666;
                font-weight: 500;
                font-size: 0.9rem;
            }

            .detail-value {
                color: #333;
                font-size: 1rem;
            }

            .status-badge {
                display: inline-block;
                padding: 0.3rem 0.6rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .status-Available {
                color: #155724;
                background-color: #d4edda;
            }

            .status-NotAvailable {
                color: #721c24;
                background-color: #f8d7da;
            }

            .action-buttons {
                margin-top: 2rem;
                display: flex;
                gap: 1rem;
            }

            .action-buttons .btn {
                padding: 0.5rem 1rem;
                font-weight: 500;
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
                .details-grid {
                    grid-template-columns: 1fr;
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
                    String vehicleId = request.getParameter("id");
                    Vehicles vehicle = null;
                    if (vehicleId != null) {
                        vehicle = vehicleDAO.getVehicleById(vehicleId);
                    }
                %>

                <div class="dashboard-header">
                    <h2>Vehicle Details</h2>
                    <a href="admin-vehicles.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Vehicles
                    </a>
                </div>

                <% if (vehicle != null) { %>
                <div class="vehicle-card">
                    <div class="row g-0">
                        <div class="col-md-5">
                            <img src="<%= vehicle.getVehicleImagePath()%>" class="vehicle-image" alt="Vehicle Image">
                        </div>
                        <div class="col-md-7">
                            <div class="vehicle-details p-4">
                                <h3 class="vehicle-title mb-4"><%= vehicle.getBrand()%> - <%= vehicle.getModel()%></h3>
                                
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Vehicle ID</span>
                                            <span class="detail-value"><%= vehicle.getVehicleID()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Manufacturing Year</span>
                                            <span class="detail-value"><%= vehicle.getManufacturingYear()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Category</span>
                                            <span class="detail-value"><%= vehicle.getCategory()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Fuel Type</span>
                                            <span class="detail-value"><%= vehicle.getFuelType()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Transmission</span>
                                            <span class="detail-value"><%= vehicle.getTransmissionType()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Mileage</span>
                                            <span class="detail-value"><%= vehicle.getMileage()%> km</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Rate Per Day</span>
                                            <span class="detail-value">RM <%= vehicle.getRatePerDay()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Registration No</span>
                                            <span class="detail-value"><%= vehicle.getRegistrationNo()%></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="detail-item">
                                            <span class="detail-label">Availability</span>
                                            <span class="status-badge status-<%= vehicle.isAvailability() ? "Available" : "NotAvailable"%>">
                                                <%= vehicle.isAvailability() ? "Available" : "Not Available"%>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="action-buttons mt-4">
                                    <a href="editVehicle.jsp?id=<%= vehicle.getVehicleID()%>" class="btn btn-warning me-2">
                                        <i class="fas fa-edit"></i> Edit Vehicle
                                    </a>
                                    <a href="deleteVehicle.jsp?id=<%= vehicle.getVehicleID()%>" 
                                       class="btn btn-danger"
                                       onclick="return confirm('Are you sure you want to delete this vehicle?');">
                                        <i class="fas fa-trash"></i> Delete Vehicle
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="alert alert-danger" role="alert">
                    Vehicle not found. Please check the vehicle ID and try again.
                </div>
                <% } %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 