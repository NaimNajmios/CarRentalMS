<%-- 
    Document   : editVehicle
    Created on : May 7, 2025, 5:26:43 PM
    Author     : nadhi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Database.vehicleDAO, Vehicles.Vehicles" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Edit Vehicle</title>
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

            .edit-form-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 2rem;
                margin-bottom: 2rem;
            }

            .form-label {
                color: #34495e;
                font-weight: 500;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                padding: 0.75rem;
                transition: border-color 0.2s;
            }

            .form-control:focus {
                border-color: #4a90e2;
                box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
            }

            .btn {
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                border-radius: 6px;
                transition: all 0.2s;
            }

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }

            .form-check-input:checked {
                background-color: #28a745;
                border-color: #28a745;
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
                    String vehicleId = request.getParameter("id");
                    Vehicles vehicle = null;
                    if (vehicleId != null) {
                        vehicle = vehicleDAO.getVehicleById(vehicleId);
                    }
                %>

                <div class="dashboard-header">
                    <h2>Edit Vehicle</h2>
                    <a href="admin-vehicles.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Vehicles
                    </a>
                </div>

                <% if (vehicle != null) { %>
                <div class="edit-form-card">
                    <form action="${pageContext.request.contextPath}/EditVehicle" method="post">
                        <input type="hidden" name="vehicleID" value="<%= vehicle.getVehicleID()%>">
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="model" class="form-label">Model</label>
                                <input type="text" name="model" id="model" class="form-control" value="<%= vehicle.getModel()%>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="brand" class="form-label">Brand</label>
                                <input type="text" name="brand" id="brand" class="form-control" value="<%= vehicle.getBrand()%>" required>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="manufacturingYear" class="form-label">Manufacturing Year</label>
                                <input type="number" name="manufacturingYear" id="manufacturingYear" class="form-control" value="<%= vehicle.getManufacturingYear()%>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="category" class="form-label">Category</label>
                                <select name="category" id="category" class="form-select" required>
                                    <option value="" disabled>Select a category</option>
                                    <option value="Hatchback" <%= vehicle.getCategory().equals("Hatchback") ? "selected" : ""%>>Hatchback</option>
                                    <option value="Sedan" <%= vehicle.getCategory().equals("Sedan") ? "selected" : ""%>>Sedan</option>
                                    <option value="SUV" <%= vehicle.getCategory().equals("SUV") ? "selected" : ""%>>SUV</option>
                                    <option value="Van" <%= vehicle.getCategory().equals("Van") ? "selected" : ""%>>Van</option>
                                    <option value="Truck" <%= vehicle.getCategory().equals("Truck") ? "selected" : ""%>>Truck</option>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="fuelType" class="form-label">Fuel Type</label>
                                <select name="fuelType" id="fuelType" class="form-select" required>
                                    <option value="" disabled>Select fuel type</option>
                                    <option value="Petrol" <%= vehicle.getFuelType().equals("Petrol") ? "selected" : ""%>>Petrol</option>
                                    <option value="Diesel" <%= vehicle.getFuelType().equals("Diesel") ? "selected" : ""%>>Diesel</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="transmissionType" class="form-label">Transmission Type</label>
                                <select name="transmissionType" id="transmissionType" class="form-select" required>
                                    <option value="" disabled>Select transmission type</option>
                                    <option value="Auto" <%= vehicle.getTransmissionType().equals("Auto") ? "selected" : ""%>>Auto</option>
                                    <option value="Manual" <%= vehicle.getTransmissionType().equals("Manual") ? "selected" : ""%>>Manual</option>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="mileage" class="form-label">Mileage (km)</label>
                                <input type="number" name="mileage" id="mileage" class="form-control" value="<%= vehicle.getMileage()%>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="ratePerDay" class="form-label">Rate per Day (RM)</label>
                                <input type="number" step="0.01" name="ratePerDay" id="ratePerDay" class="form-control" value="<%= vehicle.getRatePerDay()%>" required>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="registrationNo" class="form-label">Registration Number</label>
                                <input type="text" name="registrationNo" id="registrationNo" class="form-control" value="<%= vehicle.getRegistrationNo()%>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="vehicleImagePath" class="form-label">Image Path</label>
                                <input type="text" name="vehicleImagePath" id="vehicleImagePath" class="form-control" value="<%= vehicle.getVehicleImagePath()%>" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Availability</label>
                            <div class="mt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="availability" id="available" value="true" <%= vehicle.isAvailability() ? "checked" : ""%>>
                                    <label class="form-check-label" for="available">Available</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="availability" id="notAvailable" value="false" <%= !vehicle.isAvailability() ? "checked" : ""%>>
                                    <label class="form-check-label" for="notAvailable">Not Available</label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Update Vehicle
                            </button>
                            <a href="viewVehicle.jsp?id=<%= vehicle.getVehicleID()%>" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
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