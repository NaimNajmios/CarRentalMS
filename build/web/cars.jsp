<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Cars Selection</title>
        <%@ include file="include/client-css.html" %>
    </head>
    <body>
        <!-- Header -->
        <%@ include file="include/header.jsp" %>

        <!-- Cars Section -->
        <section id="cars" class="py-5 mt-5">
            <div class="container">
                <h2 class="text-center mb-4 display-6 fw-bold">Available Cars</h2>
                <!-- Category Tabs -->
                <ul class="nav nav-tabs justify-content-center mb-5" id="carCategoryTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab" aria-controls="all" aria-selected="true">All</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="hatchback-tab" data-bs-toggle="tab" data-bs-target="#hatchback" type="button" role="tab" aria-controls="hatchback" aria-selected="false">Hatchback</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="sedan-tab" data-bs-toggle="tab" data-bs-target="#sedan" type="button" role="tab" aria-controls="sedan" aria-selected="false">Sedan</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="suv-tab" data-bs-toggle="tab" data-bs-target="#suv" type="button" role="tab" aria-controls="suv" aria-selected="false">SUV</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="van-tab" data-bs-toggle="tab" data-bs-target="#van" type="button" role="tab" aria-controls="van" aria-selected="false">Van</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="truck-tab" data-bs-toggle="tab" data-bs-target="#truck" type="button" role="tab" aria-controls="truck" aria-selected="false">Truck</button>
                    </li>
                </ul>
                <!-- Car Listings -->
                <div class="tab-content" id="carCategoryTabContent">
                    <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                            <!-- Car Card -->
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="images/img_1.jpg" class="card-img-top" alt="Car">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold">Land Rover Range Rover S64</h5>
                                            <p class="card-text fs-4 fw-bold mb-3">$250 <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><span class="text-muted">Brand:</span> Land Rover</li>
                                                <li><span class="text-muted">Model:</span> Range Rover S64</li>
                                                <li><span class="text-muted">Transmission:</span> Automatic</li>
                                                <li><span class="text-muted">Fuel Type:</span> Diesel</li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="#" class="btn btn-primary w-100">Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="images/img_2.jpg" class="card-img-top" alt="Car">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold">BMW X5 M50i</h5>
                                            <p class="card-text fs-4 fw-bold mb-3">$250 <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><span class="text-muted">Brand:</span> BMW</li>
                                                <li><span class="text-muted">Model:</span> X5 M50i</li>
                                                <li><span class="text-muted">Transmission:</span> Automatic</li>
                                                <li><span class="text-muted">Fuel Type:</span> Petrol</li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="#" class="btn btn-primary w-100">Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm">
                                    <img src="images/img_3.jpg" class="card-img-top" alt="Car">
                                    <div class="card-body text-center">
                                        <div class="card-details">
                                            <h5 class="card-title fw-semibold">Mercedes-Benz GLC 300</h5>
                                            <p class="card-text fs-4 fw-bold mb-3">$250 <span class="fs-6 text-muted">/day</span></p>
                                            <ul class="list-unstyled row row-cols-2 g-2 mb-4">
                                                <li><span class="text-muted">Brand:</span> Mercedes-Benz</li>
                                                <li><span class="text-muted">Model:</span> GLC 300</li>
                                                <li><span class="text-muted">Transmission:</span> Automatic</li>
                                                <li><span class="text-muted">Fuel Type:</span> Hybrid</li>
                                            </ul>
                                        </div>
                                        <div class="card-footer-btn">
                                            <a href="#" class="btn btn-primary w-100">Rent Now</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Placeholder for other tabs (empty for now) -->
                    <div class="tab-pane fade" id="hatchback" role="tabpanel" aria-labelledby="hatchback-tab"></div>
                    <div class="tab-pane fade" id="sedan" role="tabpanel" aria-labelledby="sedan-tab"></div>
                    <div class="tab-pane fade" id="suv" role="tabpanel" aria-labelledby="suv-tab"></div>
                    <div class="tab-pane fade" id="van" role="tabpanel" aria-labelledby="van-tab"></div>
                    <div class="tab-pane fade" id="truck" role="tabpanel" aria-labelledby="truck-tab"></div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <%@ include file="include/footer.jsp" %>

        <!-- JavaScript Imports -->
        <%@ include file="include/scripts.html" %>
    </body>
</html>