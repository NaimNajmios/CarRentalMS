<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle" %>

<%
    List<Vehicle> vehicles = new ArrayList<>();
    UIAccessObject uiAccessObject = new UIAccessObject();
    vehicles = uiAccessObject.getVehicleList();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Cars Selection</title>
        <%@ include file="include/client-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <!-- Header -->
        <%@ include file="include/header.jsp" %>

        <!-- Cars Section -->
        <section id="cars" class="py-5 mt-5">
            <div class="container">
                <h2 class="text-center mb-4 display-6 fw-bold"><i class="fas fa-car"></i> Available Cars</h2>
                <!-- Category Tabs -->
                <ul class="nav nav-tabs justify-content-center mb-5" id="carCategoryTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab" aria-controls="all" aria-selected="true"><i class="fas fa-th"></i> All</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="hatchback-tab" data-bs-toggle="tab" data-bs-target="#hatchback" type="button" role="tab" aria-controls="hatchback" aria-selected="false"><i class="fas fa-car-side"></i> Hatchback</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="sedan-tab" data-bs-toggle="tab" data-bs-target="#sedan" type="button" role="tab" aria-controls="sedan" aria-selected="false"><i class="fas fa-car"></i> Sedan</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="suv-tab" data-bs-toggle="tab" data-bs-target="#suv" type="button" role="tab" aria-controls="suv" aria-selected="false"><i class="fas fa-truck-monster"></i> SUV</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="van-tab" data-bs-toggle="tab" data-bs-target="#van" type="button" role="tab" aria-controls="van" aria-selected="false"><i class="fas fa-shuttle-van"></i> Van</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="truck-tab" data-bs-toggle="tab" data-bs-target="#truck" type="button" role="tab" aria-controls="truck" aria-selected="false"><i class="fas fa-truck"></i> Truck</button>
                    </li>
                </ul>
                <!-- Car Listings -->
                <div class="tab-content" id="carCategoryTabContent">
                    <!-- All Tab -->
                    <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity()) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle-details.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <!-- Hatchback Tab -->
                    <div class="tab-pane fade" id="hatchback" role="tabpanel" aria-labelledby="hatchback-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Hatchback".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <!-- Sedan Tab -->
                    <div class="tab-pane fade" id="sedan" role="tabpanel" aria-labelledby="sedan-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Sedan".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <!-- SUV Tab -->
                    <div class="tab-pane fade" id="suv" role="tabpanel" aria-labelledby="suv-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "SUV".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <!-- Van Tab -->
                    <div class="tab-pane fade" id="van" role="tabpanel" aria-labelledby="van-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Van".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                    <!-- Truck Tab -->
                    <div class="tab-pane fade" id="truck" role="tabpanel" aria-labelledby="truck-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Truck".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="<%= vehicle.getVehicleImagePath()%>" class="card-img-top" alt="<%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%>">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold"><%= vehicle.getVehicleBrand()%> <%= vehicle.getVehicleModel()%></h5>
                                            <p class="card-text fs-4 fw-bold mb-3">RM<%= vehicle.getVehicleRatePerDay()%> <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><i class="fas fa-tag"></i> <span class="text-muted">Brand:</span> <%= vehicle.getVehicleBrand()%></li>
                                                <li><i class="fas fa-car"></i> <span class="text-muted">Model:</span> <%= vehicle.getVehicleModel()%></li>
                                                <li><i class="fas fa-cog"></i> <span class="text-muted">Transmission:</span> <%= vehicle.getTransmissionType()%></li>
                                                <li><i class="fas fa-gas-pump"></i> <span class="text-muted">Fuel Type:</span> <%= vehicle.getVehicleFuelType()%></li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="vehicle.jsp?vehicleId=<%= vehicle.getVehicleId()%>" class="btn btn-primary w-100"><i class="fas fa-key"></i> Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
                <!-- Pagination (Placeholder, can be implemented dynamically if needed) -->
                <nav aria-label="Page navigation" class="mt-5">
                    <ul class="pagination justify-content-center">
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                    </ul>   
                </nav>
            </div>
        </section>

        <!-- Footer -->
        <%@ include file="include/footer.jsp" %>

        <!-- JavaScript Imports -->
        <%@ include file="include/scripts.html" %>
    </body>
</html>