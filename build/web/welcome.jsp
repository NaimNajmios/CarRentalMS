<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
    Document   : welcome
    Created on : 5 Jun 2025, 1:30:00 PM
    Author     : Cursor
    Description: Welcome page for non-logged-in users
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Welcome</title>
    <%@ include file="include/client-css.html" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            padding-top: 56px; /* Adjust for fixed header */
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }

        .hero-section {
            background: linear-gradient(135deg, #007bff, #0056b3); /* Modern gradient */
            color: #fff;
            padding: 80px 0;
            text-align: center;
            margin-bottom: 3rem;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            position: relative;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            transform: rotate(45deg);
            pointer-events: none;
            z-index: 1;
        }

        .hero-section > .container {
            position: relative;
            z-index: 2;
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-section p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .card-feature {
            text-align: center;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            background-color: #fff;
        }

        .card-feature:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
        }

        .card-feature .icon {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 15px;
        }

        .card-feature h5 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .card-feature p {
            color: #666;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 2.5rem;
            text-align: center;
        }

        .welcome-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            height: 100%;
        }

        .welcome-card .card-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #007bff;
            margin-bottom: 1.5rem;
        }

        .welcome-card .list-unstyled li a {
            font-size: 1.1rem;
            color: #555;
            padding: 0.75rem 0;
            display: flex;
            align-items: center;
            transition: color 0.2s;
        }

        .welcome-card .list-unstyled li a:hover {
            color: #007bff;
        }

        .welcome-card .list-unstyled li i {
            margin-right: 12px;
            color: #007bff;
        }

        .welcome-card .btn {
            margin-top: 1.5rem;
        }

        .quick-access-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .quick-access-grid li a {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .quick-access-grid li a:hover {
            background-color: #e2e6ea;
            border-color: #dae0e5;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .quick-access-grid li a i {
            font-size: 1.5rem;
            color: #007bff;
            margin-right: 15px;
        }

        .cta-section {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: #fff;
            padding: 3rem 0;
            border-radius: 12px;
            text-align: center;
            margin: 3rem 0;
        }

        .cta-section h3 {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .cta-section p {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        /* Footer Styles */
        footer {
            margin-top: auto;
        }
        footer .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        footer .social-links a:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }
        footer .text-light-emphasis {
            color: rgba(255, 255, 255, 0.7) !important;
        }
        footer .text-light-emphasis:hover {
            color: #fff !important;
        }
        footer ul li a {
            transition: all 0.3s ease;
        }
        footer ul li a:hover {
            padding-left: 5px;
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 40px 0;
            }
            .hero-section h1 {
                font-size: 2.5rem;
            }
            .hero-section p {
                font-size: 1rem;
            }
            .section-title {
                font-size: 1.8rem;
            }
            .welcome-card {
                padding: 1.5rem;
            }
            .cta-section h3 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <nav class="navbar navbar-expand-lg bg-white shadow-sm fixed-top">
            <div class="container">
                <a class="navbar-brand" href="welcome.jsp"><i class="fas fa-car"></i> CarRent</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="welcome.jsp">
                                <i class="fas fa-home"></i> Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link btn btn-outline-primary px-4 py-2 ms-3 rounded-pill fw-semibold" href="login.jsp" style="border-width: 2px; transition: all 0.3s ease;">
                                <i class="fas fa-sign-in-alt me-2"></i> Login
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <main class="container mt-5 pt-5">
        <section class="hero-section">
            <div class="container">
                <h1>Welcome to CarRent!</h1>
                <p>Your journey to the perfect car starts here. Explore our vast fleet of vehicles, from economy to luxury, and find the perfect ride for your needs.</p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="cars-browse.jsp" class="btn btn-light btn-lg rounded-pill px-4">Browse Cars <i class="fas fa-arrow-right ms-2"></i></a>
                    <a href="login.jsp" class="btn btn-outline-light btn-lg rounded-pill px-4">Login <i class="fas fa-sign-in-alt ms-2"></i></a>
                </div>
            </div>
        </section>

        <section class="mb-5">
            <h2 class="section-title">Why Choose CarRent?</h2>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-car"></i></div>
                        <h5>Vast Car Selection</h5>
                        <p>Browse a wide range of vehicles, from economy to luxury, and find the perfect one for your needs.</p>
                        <a href="cars-browse.jsp" class="btn btn-outline-primary btn-sm rounded-pill">View Cars</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-shield-alt"></i></div>
                        <h5>Safe & Reliable</h5>
                        <p>All our vehicles are thoroughly inspected and maintained to ensure your safety and comfort.</p>
                        <a href="cars-browse.jsp" class="btn btn-outline-primary btn-sm rounded-pill">Learn More</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-clock"></i></div>
                        <h5>24/7 Support</h5>
                        <p>Our customer support team is available round the clock to assist you with any queries.</p>
                        <a href="contact.jsp" class="btn btn-outline-primary btn-sm rounded-pill">Contact Us</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-section">
            <div class="container">
                <h3>Ready to Start Your Journey?</h3>
                <p>Join thousands of satisfied customers who trust CarRent for their transportation needs.</p>
                <a href="login.jsp" class="btn btn-light btn-lg rounded-pill px-4">Get Started <i class="fas fa-arrow-right ms-2"></i></a>
            </div>
        </section>

        <section class="welcome-sections mb-5">
            <h2 class="section-title">Explore Our Services</h2>
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="welcome-card">
                        <h5 class="card-title">Browse Our Fleet</h5>
                        <p class="card-text text-muted">Discover our extensive collection of vehicles. From compact cars to luxury SUVs, we have something for everyone.</p>
                        <a href="cars-browse.jsp" class="btn btn-outline-primary rounded-pill">Explore Cars <i class="fas fa-arrow-right ms-2"></i></a>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="welcome-card">
                        <h5 class="card-title">Quick Access</h5>
                        <ul class="list-unstyled quick-access-grid">
                            <li><a href="cars-browse.jsp"><i class="fas fa-car"></i>View All Cars</a></li>
                            <li><a href="about.jsp"><i class="fas fa-info-circle"></i>About Us</a></li>
                            <li><a href="contact.jsp"><i class="fas fa-envelope"></i>Contact Us</a></li>
                            <li><a href="login.jsp"><i class="fas fa-sign-in-alt"></i>Login</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <section class="mb-5">
            <h2 class="section-title">Popular Car Categories</h2>
            <div class="row row-cols-1 row-cols-md-4 g-4">
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-car-side"></i></div>
                        <h5>Hatchback</h5>
                        <p>Perfect for city driving and fuel efficiency.</p>
                        <a href="cars-browse.jsp#hatchback" class="btn btn-outline-primary btn-sm rounded-pill">View Hatchbacks</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-car"></i></div>
                        <h5>Sedan</h5>
                        <p>Comfortable and spacious for family trips.</p>
                        <a href="cars-browse.jsp#sedan" class="btn btn-outline-primary btn-sm rounded-pill">View Sedans</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-truck-monster"></i></div>
                        <h5>SUV</h5>
                        <p>Powerful and versatile for any terrain.</p>
                        <a href="cars-browse.jsp#suv" class="btn btn-outline-primary btn-sm rounded-pill">View SUVs</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-shuttle-van"></i></div>
                        <h5>Van</h5>
                        <p>Spacious and perfect for group travel.</p>
                        <a href="cars-browse.jsp#van" class="btn btn-outline-primary btn-sm rounded-pill">View Vans</a>
                    </div>
                </div>
            </div>
        </section>

    </main>

    <!-- Footer -->
    <footer class="bg-dark text-light py-5">
        <div class="container">
            <div class="row g-4">
                <!-- Contact Info -->
                <div class="col-lg-4 col-md-6">
                    <h3 class="h5 fw-semibold text-white mb-3">Contact Us</h3>
                    <ul class="list-unstyled small">
                        <li class="mb-2">
                            <i class="fas fa-map-marker-alt me-2"></i>
                            Universiti Malaysia Terengganu,<br>
                            21030 Kuala Nerus,<br>
                            Terengganu, Malaysia
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-phone me-2"></i>
                            +60 9-668 4100
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-envelope me-2"></i>
                            contact@carrental.com
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-clock me-2"></i>
                            Mon - Fri: 8:00 AM - 5:00 PM
                        </li>
                    </ul>
                </div>

                <!-- Quick Links -->
                <div class="col-lg-2 col-md-6">
                    <h3 class="h5 fw-semibold text-white mb-3">Quick Links</h3>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="welcome.jsp" class="text-light-emphasis text-decoration-none">Home</a></li>
                        <li class="mb-2"><a href="cars-browse.jsp" class="text-light-emphasis text-decoration-none">Cars</a></li>
                        <li class="mb-2"><a href="about.jsp" class="text-light-emphasis text-decoration-none">About Us</a></li>
                        <li class="mb-2"><a href="contact.jsp" class="text-light-emphasis text-decoration-none">Contact</a></li>
                    </ul>
                </div>

                <!-- Company Info -->
                <div class="col-lg-4 col-md-6">
                    <h3 class="h5 fw-semibold text-white mb-3">CarRent</h3>
                    <p class="small text-light-emphasis mb-4">Your trusted partner for premium car rentals. Experience luxury and comfort with our extensive fleet of vehicles.</p>
                    <div class="social-links">
                        <a href="#" class="text-light me-3" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-light me-3" title="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-light me-3" title="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-light" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="border-top border-secondary pt-4 mt-4">
                <div class="row align-items-center">
                    <div class="col-md-6 text-center text-md-start small">
                        <p class="mb-0">© <script>document.write(new Date().getFullYear());</script> CarRent. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-center text-md-end small">
                        <a href="privacy-policy.jsp" class="text-light-emphasis text-decoration-none me-3">Privacy Policy</a>
                        <a href="terms.jsp" class="text-light-emphasis text-decoration-none">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- JavaScript Imports -->
    <%@ include file="include/scripts.html" %>
</body>
</html> 