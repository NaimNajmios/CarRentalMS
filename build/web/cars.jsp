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
        <style>
            /* Fix card consistency issues */
            .card {
                height: 100%;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
            }
            
            /* Fix image sizing and consistency */
            .card-img-top {
                width: 100%;
                height: 200px; /* Fixed height for all images */
                object-fit: cover; /* Maintains aspect ratio while covering the container */
                object-position: center; /* Centers the image */
                border-top-left-radius: 0.375rem;
                border-top-right-radius: 0.375rem;
            }
            
            /* Ensure card body has consistent spacing */
            .card-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                height: 100%;
                padding: 1.25rem;
            }
            
            .card-details {
                flex-grow: 1;
            }
            
            .card-footer-btn {
                margin-top: auto;
            }
            
            /* Ensure consistent text sizing */
            .card-title {
                font-size: 1.1rem;
                line-height: 1.3;
                margin-bottom: 0.75rem;
                min-height: 2.6rem; /* Fixed height for title area */
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .card-text {
                margin-bottom: 1rem;
            }
            
            /* Fix list styling for consistent spacing */
            .list-unstyled li {
                font-size: 0.85rem;
                margin-bottom: 0.25rem;
                line-height: 1.2;
            }
            
            /* Ensure button consistency */
            .btn {
                font-size: 0.9rem;
                padding: 0.5rem 1rem;
            }
            
            /* Search bar styling */
            .search-container {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 2rem 0;
                margin-bottom: 2rem;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }
            
            .search-form {
                max-width: 800px;
                margin: 0 auto;
            }
            
            .search-input {
                border: none;
                border-radius: 25px;
                padding: 12px 20px;
                font-size: 1rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }
            
            .search-input:focus {
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
            }
            
            .search-btn {
                border-radius: 25px;
                padding: 12px 25px;
                background: linear-gradient(45deg, #ff6b6b, #ee5a24);
                border: none;
                color: white;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            
            .search-btn:hover {
                background: linear-gradient(45deg, #ee5a24, #ff6b6b);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(238, 90, 36, 0.3);
            }
            
            .filter-options {
                margin-top: 1rem;
            }
            
            .filter-select {
                border: none;
                border-radius: 15px;
                padding: 8px 15px;
                font-size: 0.9rem;
                background: rgba(255, 255, 255, 0.9);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            
            .filter-select:focus {
                outline: none;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
            }
            
            /* Hidden cards */
            .vehicle-card.hidden {
                display: none;
            }
            
            /* No results message */
            .no-results {
                text-align: center;
                padding: 3rem;
                color: #6c757d;
                font-size: 1.1rem;
            }
            
            .no-results i {
                font-size: 3rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }
            
            /* Responsive adjustments */
            @media (max-width: 768px) {
                .card-img-top {
                    height: 180px;
                }
                
                .card-title {
                    font-size: 1rem;
                    min-height: 2.4rem;
                }
                
                .list-unstyled li {
                    font-size: 0.8rem;
                }
                
                .search-container {
                    padding: 1.5rem 1rem;
                }
                
                .filter-options .col-md-3 {
                    margin-bottom: 0.5rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <%@ include file="include/header.jsp" %>

        <!-- Cars Section -->
        <section id="cars" class="py-5 mt-5">
            <div class="container">
                <h2 class="text-center mb-4 display-6 fw-bold"><i class="fas fa-car"></i> Available Cars</h2>
                
                <!-- Search Bar -->
                <div class="search-container">
                    <div class="search-form">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-white border-0">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control search-input" id="searchInput" placeholder="Search by brand, model, transmission, or fuel type...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select filter-select" id="priceFilter">
                                    <option value="">All Prices</option>
                                    <option value="0-50">Under RM50/day</option>
                                    <option value="50-100">RM50 - RM100/day</option>
                                    <option value="100-150">RM100 - RM150/day</option>
                                    <option value="150-200">RM150 - RM200/day</option>
                                    <option value="200+">Over RM200/day</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn search-btn w-100" onclick="performSearch()">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                        <div class="filter-options">
                            <div class="row g-2">
                                <div class="col-md-3">
                                    <select class="form-select filter-select" id="transmissionFilter">
                                        <option value="">All Transmissions</option>
                                        <option value="Manual">Manual</option>
                                        <option value="Automatic">Automatic</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select filter-select" id="fuelFilter">
                                        <option value="">All Fuel Types</option>
                                        <option value="Petrol">Petrol</option>
                                        <option value="Diesel">Diesel</option>
                                        <option value="Electric">Electric</option>
                                        <option value="Hybrid">Hybrid</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select filter-select" id="brandFilter">
                                        <option value="">All Brands</option>
                                        <%
                                            java.util.Set<String> brands = new java.util.HashSet<>();
                                            for (Vehicle vehicle : vehicles) {
                                                if (vehicle.getVehicleAvailablity()) {
                                                    brands.add(vehicle.getVehicleBrand());
                                                }
                                            }
                                            for (String brand : brands) {
                                        %>
                                        <option value="<%= brand %>"><%= brand %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="button" class="btn btn-outline-light w-100" onclick="clearFilters()">
                                        <i class="fas fa-times"></i> Clear Filters
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
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
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="allVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity()) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="<%= vehicle.getVehicleCategory().toLowerCase() %>">
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
                        <div class="no-results" id="noResultsAll" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
                        </div>
                    </div>
                    
                    <!-- Hatchback Tab -->
                    <div class="tab-pane fade" id="hatchback" role="tabpanel" aria-labelledby="hatchback-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="hatchbackVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Hatchback".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="hatchback">
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
                        <div class="no-results" id="noResultsHatchback" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No hatchback vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
                        </div>
                    </div>
                    
                    <!-- Sedan Tab -->
                    <div class="tab-pane fade" id="sedan" role="tabpanel" aria-labelledby="sedan-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="sedanVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Sedan".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="sedan">
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
                        <div class="no-results" id="noResultsSedan" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No sedan vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
                        </div>
                    </div>
                    
                    <!-- SUV Tab -->
                    <div class="tab-pane fade" id="suv" role="tabpanel" aria-labelledby="suv-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="suvVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "SUV".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="suv">
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
                        <div class="no-results" id="noResultsSuv" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No SUV vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
                        </div>
                    </div>
                    
                    <!-- Van Tab -->
                    <div class="tab-pane fade" id="van" role="tabpanel" aria-labelledby="van-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="vanVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Van".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="van">
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
                        <div class="no-results" id="noResultsVan" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No van vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
                        </div>
                    </div>
                    
                    <!-- Truck Tab -->
                    <div class="tab-pane fade" id="truck" role="tabpanel" aria-labelledby="truck-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" id="truckVehicles">
                            <%
                                for (Vehicle vehicle : vehicles) {
                                    if (vehicle.getVehicleAvailablity() && "Truck".equalsIgnoreCase(vehicle.getVehicleCategory())) {
                            %>
                            <div class="col vehicle-card" 
                                 data-brand="<%= vehicle.getVehicleBrand().toLowerCase() %>"
                                 data-model="<%= vehicle.getVehicleModel().toLowerCase() %>"
                                 data-transmission="<%= vehicle.getTransmissionType().toLowerCase() %>"
                                 data-fuel="<%= vehicle.getVehicleFuelType().toLowerCase() %>"
                                 data-price="<%= vehicle.getVehicleRatePerDay() %>"
                                 data-category="truck">
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
                        <div class="no-results" id="noResultsTruck" style="display: none;">
                            <i class="fas fa-search"></i>
                            <h4>No truck vehicles found</h4>
                            <p>Try adjusting your search criteria or filters</p>
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
        
        <!-- Search Functionality JavaScript -->
        <script>
            // Search functionality
            function performSearch() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const priceFilter = document.getElementById('priceFilter').value;
                const transmissionFilter = document.getElementById('transmissionFilter').value.toLowerCase();
                const fuelFilter = document.getElementById('fuelFilter').value.toLowerCase();
                const brandFilter = document.getElementById('brandFilter').value.toLowerCase();
                
                // Get all vehicle cards in the current active tab
                const activeTab = document.querySelector('.tab-pane.active');
                const vehicleCards = activeTab.querySelectorAll('.vehicle-card');
                const noResultsElement = activeTab.querySelector('.no-results');
                
                let visibleCount = 0;
                
                vehicleCards.forEach(card => {
                    const brand = card.dataset.brand;
                    const model = card.dataset.model;
                    const transmission = card.dataset.transmission;
                    const fuel = card.dataset.fuel;
                    const price = parseFloat(card.dataset.price);
                    const category = card.dataset.category;
                    
                    // Check search term
                    const matchesSearch = searchTerm === '' || 
                        brand.includes(searchTerm) || 
                        model.includes(searchTerm) || 
                        transmission.includes(searchTerm) || 
                        fuel.includes(searchTerm);
                    
                    // Check price filter
                    let matchesPrice = true;
                    if (priceFilter) {
                        const [min, max] = priceFilter.split('-');
                        if (max === '+') {
                            matchesPrice = price >= parseFloat(min);
                        } else {
                            matchesPrice = price >= parseFloat(min) && price <= parseFloat(max);
                        }
                    }
                    
                    // Check transmission filter
                    const matchesTransmission = transmissionFilter === '' || transmission === transmissionFilter;
                    
                    // Check fuel filter
                    const matchesFuel = fuelFilter === '' || fuel === fuelFilter;
                    
                    // Check brand filter
                    const matchesBrand = brandFilter === '' || brand === brandFilter;
                    
                    // Show/hide card based on all filters
                    if (matchesSearch && matchesPrice && matchesTransmission && matchesFuel && matchesBrand) {
                        card.classList.remove('hidden');
                        visibleCount++;
                    } else {
                        card.classList.add('hidden');
                    }
                });
                
                // Show/hide no results message
                if (visibleCount === 0) {
                    noResultsElement.style.display = 'block';
                } else {
                    noResultsElement.style.display = 'none';
                }
            }
            
            // Clear all filters
            function clearFilters() {
                document.getElementById('searchInput').value = '';
                document.getElementById('priceFilter').value = '';
                document.getElementById('transmissionFilter').value = '';
                document.getElementById('fuelFilter').value = '';
                document.getElementById('brandFilter').value = '';
                
                // Show all cards and hide no results message
                const activeTab = document.querySelector('.tab-pane.active');
                const vehicleCards = activeTab.querySelectorAll('.vehicle-card');
                const noResultsElement = activeTab.querySelector('.no-results');
                
                vehicleCards.forEach(card => {
                    card.classList.remove('hidden');
                });
                
                noResultsElement.style.display = 'none';
            }
            
            // Add event listeners for real-time search
            document.addEventListener('DOMContentLoaded', function() {
                const searchInput = document.getElementById('searchInput');
                const priceFilter = document.getElementById('priceFilter');
                const transmissionFilter = document.getElementById('transmissionFilter');
                const fuelFilter = document.getElementById('fuelFilter');
                const brandFilter = document.getElementById('brandFilter');
                
                // Real-time search on input change
                searchInput.addEventListener('input', performSearch);
                priceFilter.addEventListener('change', performSearch);
                transmissionFilter.addEventListener('change', performSearch);
                fuelFilter.addEventListener('change', performSearch);
                brandFilter.addEventListener('change', performSearch);
                
                // Handle tab changes to reset search for new tab
                const tabButtons = document.querySelectorAll('[data-bs-toggle="tab"]');
                tabButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        // Clear filters when switching tabs
                        setTimeout(() => {
                            clearFilters();
                        }, 100);
                    });
                });
            });
        </script>
    </body>
</html>